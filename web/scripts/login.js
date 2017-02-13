/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
window.onload = function ()
{
    if (typeof history.pushState === "function") {
        history.pushState("jibberish", null, null);
        window.onpopstate = function () {
            history.pushState('newjibberish', null, null);
            // Handle the back (or forward) buttons here
            // Will NOT handle refresh, use onbeforeunload for this.
        };
    } else {
        var ignoreHashChange = true;
        window.onhashchange = function () {
            if (!ignoreHashChange) {
                ignoreHashChange = true;
                window.location.hash = Math.random();
                // Detect and redirect change here
                // Works in older FF and IE9
                // * it does mess with your hash symbol (anchor?) pound sign
                // delimiter on the end of the URL
            } else {
                ignoreHashChange = false;
            }
        };
    }
}
var res = 0;
function nobackbutton()
{
    window.location.hash = "no-back-button";
    window.location.hash = "Again-No-back-button";
    window.onhashchange = function () {
        window.location.hash = "no-back-button";
    }
}

function cambio()
{
    var txt = document.getElementById("userU").value;

    if (txt == "")
    {
        res = 1;
    } else {
        res = 0;
    }
    boton();
}

function boton()
{
    if (res == "1")
    {
        document.getElementById("booton").style.opacity = '0.6';
        document.getElementById("booton").style.cursor = 'not-allowed';
        document.getElementById("booton").disabled = true;
    } else
    {
        document.getElementById("booton").style.opacity = '1';
        document.getElementById("booton").style.cursor = 'pointer';
        document.getElementById("booton").disabled = false;
    }
}
function valida(){
    var correo = document.getElementById("correo").value;
    var contra = document.getElementById("contra").value;
    var code = 0;
    var pass = [false];
    for(var i = 0; i < correo.length; i++){
    //regular expresion taken from: http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
        code = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if(code.test(correo)){
            pass[0] = true;
        }else{
            pass[0] = false;
        }
    }
    for(var i = 0; i < contra.length; i++){
        code = contra.charCodeAt(i);
        if(code < 44 ||
          (code > 46 && code < 48) ||
          (code > 57 && code < 65) ||
          (code > 90 && code < 97) ||
           code > 127){
            pass[1] = false;
        }else{
            pass[1] = true;
        }
    }
    if(pass[0]){
        if(pass[1]){
            elform.submit();
        }else{
            alert("Contraseña inválida.\n Revisa que no contenga carácteres especiales.");
        }
    }else{
        alert("Correo inválido.\n Revisa que no contenga carácteres especiales.");
    }
}