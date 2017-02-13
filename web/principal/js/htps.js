/*JavaScript Document*/

var txt = ""

function cod ()
{
    txt = codigo.value;
    document.getElementById("res").innerHTML = txt;
}

function borrar()
{
    codigo.value = "";
    document.getElementById("res").innerHTML = "";
}