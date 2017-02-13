/*JavaScript Document*/
function active(button)
{
    var div1 = document.getElementById("div1");
    var div2 = document.getElementById("div2");
    var z = 0;

    if(button.value == "SI")
    {
        div1.style.display = "block";
        div2.style.display = "none";
        z += 1;
    }else{
        div2.style.display = "block";
        div1.style.display = "none";
        z += 1;
    }
    if (z > 0)
    {
        document.getElementById("foot").style.position='relative';
    }else
    {
        document.getElementById("foot").style.position='absolute';
    }
}

function change()
{
    document.getElementById("especial1").innerHTML = document.getElementById("codigo").value;
}
       
function change2()
{
    document.getElementById("especial2").innerHTML = '<p style="color:'+document.getElementById("style1").value+';background-color:'+document.getElementById("style2").value+';font-family:'+document.getElementById("style3").value+';font-size:'+document.getElementById("style4").value+';">'+document.getElementById("parrafo").value+'</p>';
}

var txt = ""

function cod() 
{
    var txt = frase.value;
    var col = "";
    var siz = "";
    var fon = "";
    var bol = "";
    var italic = "";
    var under = "";
    var color = document.getElementsByName("color");
    var size = document.getElementsByName("size");
    var font = document.getElementsByName("font");

    if (document.getElementById("bold").checked)
        bol = bold.value;
    else
        bol = "";

    if (document.getElementById("ita").checked)
        italic = ita.value;
    else
        italic = "";

    if (document.getElementById("und").checked)
        under = und.value;
    else
        under = "";

    for (var i = 0; i < color.length; i++)
    {
        if(color[i].checked)
            col = color[i].value;
    }

    for (var j = 0; j < size.length; j++) 
    {
        if (size[j].checked)
            siz = size[j].value;
    }

    for (var k = 0; k < font.length; k++) 
    {
        if (font[k].checked)
            fon = font[k].value;
    }

    document.getElementById("res").innerHTML = '<font size="6">ASI SERIA TU ESTILO:</font><br/><br/>'+under+italic+bol+'<font color="' + col + '" size="' +siz+'" face="' +fon+ '">'+txt;
}

function borrar() {
    frase.value = "";
    document.getElementById("red").checked = true;
    document.getElementById("1").checked = true;
    document.getElementById("csms").checked = true;
    document.getElementById("bold").checked = false;
    document.getElementById("ita").checked = false;
    document.getElementById("und").checked = false;
    document.getElementById("res").innerHTML = "";
}