// Transform a Stata data set into the format required by Obiba Opal
// 1. Generate a matrix describing each variable
// 2. Generate a second matrix that contains information about variable categories
// 3. Output to Excel file
// 4. Convert some data formats
// 5. Output to CSV file

//  
// Author: Tom Bishop
//         
// Date: 15/09/2016

// main code
// inputs to the function are location, study name and replace (optional,
// allows you to overwrite files)
program codebookconvert
 version 14
 local file "`1'\`2'.xls, `3'"
 local 0 `"using `file'"'
 syntax using/ [, REPLACE]
 if "`replace'"=="" {
	confirm new file `"`using'"'
}
 quietly local filename "$S_FN"
 // create the matrices containing variable and category information
 mata: A=mata_variablesout()
 mata: B=mata_categoryout()
 clear
 // do some work for the Variables sheet
 getmata(Dtable Vname Vtype Dunit Vlabel Vformat)=A
 label variable Dtable "table"
 label variable Vname "name"
 label variable Vtype "valueType"
 label variable Dunit "unit"
 label variable Vlabel "label" 
 label variable Vformat "format"
 // convert variable types to match Opal
 quietly replace Vtype="integer" if Vtype=="int" | Vtype=="byte" 
 quietly replace Vtype="decimal" if Vtype=="float" | Vtype=="double" 
 quietly replace Vtype="text"  if regexm(Vtype,"str")
 quietly replace Vtype="date"  if regexm(Vformat,"%d")
 quietly replace Vtype="datetime"  if regexm(Vformat,"%td")
 drop Vformat
 quietly replace Dtable="`2'"
 order Dtable Vname Vtype Dunit Vlabel
 // export to Variables sheet in excel file
 export excel using "`using'", sheet("Variables") firstrow(varlabels) `replace'
 clear
 // do some work for Categories sheet
 getmata(Table Variable Name Label Missing)=B
 destring(Name), replace
 destring(Missing), replace
 label variable Table "table"
 label variable Variable "variable"
 label variable Name "name"
 label variable Label "label"
 label variable Missing "missing"
 // insert the table name
 quietly replace Table="`2'"
 order Table Variable Name Label Missing 
 // export to Categories sheet in Excel file
 export excel using "`using'",  sheet("Categories") firstrow(varlabels)
 quietly use "`filename'",clear
 // export the data to CSV after putting dates in ISO format
 local file "`1'\`2'.csv, `3'"
 local 0 `"using `file'"'
 syntax using/ [, REPLACE]
 if "`replace'"=="" {
	confirm new file `"`using'"'
}
 qui ds, has(format %d*)
 if "`r(varlist)'"!="" {
	format `r(varlist)' %dCCYY-NN-DD
	}
 qui ds, has(format %td*)
  if "`r(varlist)'"!="" {
	format `r(varlist)' %dCCYY-NN-DD!THH:MM:SS
 }
 //mvencode _all, mv(-1)
 export delimited using "`using'", nolabel `replace'
 quietly use "`filename'",clear
end


// Matrix generation functions

clear mata
mata:
function mata_variablesout(){
nv=st_nvar()
A=J(0,6,"")
for(i=1; i<=nv; i++ ){
   b= "",st_varname(i),st_vartype(i),"",st_varlabel(i),st_varformat(i)
   A=A\b
 }
 return(A)
}

function mata_categoryout(){
nv=st_nvar()
B=J(0,5,"")
for(i=1; i<=nv; i++ ){
 if(st_varvaluelabel(i)!=""){
    
   st_vlload(st_varvaluelabel(i), values=., text=.)
   a2=(strofreal(values),text)
   dum=length(a2[.,1])
   a2_2=J(dum,1,"0")
   a2=a2,a2_2
   a2_3="-9999","Missing","1"
   a2=a2\a2_3
   dum=dum+1
   a1=J(dum,1,("",st_varname(i))) 
   a=a1,a2
   B=B\a
  }
  else{
   b="",st_varname(i),"-9999","Missing","1"
   B=B\b
  }
 }
 return(B)
}
end
