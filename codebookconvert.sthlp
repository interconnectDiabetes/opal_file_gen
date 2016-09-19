{smcl}
{* *! version 1.2.0  02jun2011}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "examplehelpfile##syntax"}{...}
{viewerjumpto "Description" "examplehelpfile##description"}{...}
{viewerjumpto "Options" "examplehelpfile##options"}{...}
{viewerjumpto "Remarks" "examplehelpfile##remarks"}{...}
{viewerjumpto "Examples" "examplehelpfile##examples"}{...}
{title:Title}

{phang}
{bf:codebookconvert} {hline 2} Save codebook and data in Opal format


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:codebookconvert}
{it:{ target_folder table_name}}
[{cmd:,} {it:options}]


{title:Description}

{pstd}
{cmd:codebookconvert} saves codebook and data in Opal format for all the variables in the existing dataset into files in the target location. 

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt target_folder} location where files will be generated.

{phang}
{opt table_name} This will be the name of the table generated in Opal.

{phang}
{opt replace} overwrite existing dataset.
     

{marker remarks}{...}
{title:Remarks}

{pstd}
For feedback please email to trpb2@cam.ac.uk


{marker examples}{...}
{title:Examples}



{phang}{cmd:. codebookconvert D:\ new_table replace"}{p_end}
