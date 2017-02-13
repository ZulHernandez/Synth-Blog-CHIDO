/*JavaScript Document*/

var a = 0;
var b = 0;
var z = 0;

function red(val) {
    if (val == 1) {
        if (a % 2 == 0) {
            a++;
            document.getElementById("gdte").style.display='block';
            document.getElementById("gdt").style.background='rgba(20,113,143,0.8)';
            document.getElementById("gdt").style.padding='10px';
            z += 1;
        } else {
            a++;
            document.getElementById("gdte").style.display='none';
            document.getElementById("gdt").style.background='transparent';
            document.getElementById("gdt").style.padding='0px';
            z -= 1;
        }
    } else
        if (val == 2) {
            if (b % 2 == 0) {
                b++;
                document.getElementById("syn").style.display='block';
                document.getElementById("sy").style.background='rgba(20,113,143,0.8)';
                document.getElementById("sy").style.padding='10px';
                z += 1;
            } else {
                b++;
                document.getElementById("syn").style.display='none';
                document.getElementById("sy").style.background='transparent';
                document.getElementById("sy").style.padding='0px';
                z -= 1;
            }
        }
    
    if (z > 0)
    {
        document.getElementById("foot").style.position='relative';
    }else
    {
        document.getElementById("foot").style.position='absolute';
    }
}
