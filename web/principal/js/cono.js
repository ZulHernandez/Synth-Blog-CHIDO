/*JavaScript Document*/

var a = 0;
var b = 0;
var c = 0;
var d = 0;
var e = 0;
var f = 0;
var z = 0;

function red(val)
{
    if (val == 1)
    {
        if (a % 2 == 0) {
            a++;
            document.getElementById("hist").style.display='block';
            document.getElementById("his").style.background='rgba(20,113,143,0.8)';
            document.getElementById("his").style.padding='10px';
            z += 1;
        } else {
            a++;
            document.getElementById("hist").style.display='none';
            document.getElementById("his").style.background='transparent';
            document.getElementById("his").style.padding='0px';
            z -= 1;
        }
    }else
        if (val == 2)
        {
            if (b % 2 == 0) {
                b++;
                document.getElementById("orga").style.display='block';
                document.getElementById("org").style.background='rgba(20,113,143,0.8)';
                document.getElementById("org").style.padding='10px';
                z += 1;
            } else {
                b++;
                document.getElementById("orga").style.display='none';
                document.getElementById("org").style.background='transparent';
                document.getElementById("org").style.padding='0px';
                z -= 1;
            }
        }else
            if (val == 3)
            {
                if (c % 2 == 0) {
                    c++;
                    document.getElementById("estr").style.display='block';
                    document.getElementById("est").style.background='rgba(20,113,143,0.8)';
                    document.getElementById("est").style.padding='10px';
                    z += 1;
                } else {
                    c++;
                    document.getElementById("estr").style.display='none';
                    document.getElementById("est").style.background='transparent';
                    document.getElementById("est").style.padding='0px';
                    z -= 1;
                }
            }else
                if (val == 4)
                {
                    if (d % 2 == 0) {
                        d++;
                        document.getElementById("logo").style.display='block';
                        document.getElementById("log").style.background='rgba(20,113,143,0.8)';
                        document.getElementById("log").style.padding='10px';
                        z += 1;
                    } else {
                        d++;
                        document.getElementById("logo").style.display='none';
                        document.getElementById("log").style.background='transparent';
                        document.getElementById("log").style.padding='0px';
                        z -= 1;
                    }
                }else
                    if (val == 5)
                    {
                        if (e % 2 == 0) {
                            e++;
                            document.getElementById("mivis").style.display='block';
                            document.getElementById("mivi").style.background='rgba(20,113,143,0.8)';
                            document.getElementById("mivi").style.padding='10px';
                            z += 1;
                        } else {
                            e++;
                            document.getElementById("mivis").style.display='none';
                            document.getElementById("mivi").style.background='transparent';
                            document.getElementById("mivi").style.padding='0px';
                            z -= 1;
                        }
                    }else
                        if (val == 6) {
                            if (f % 2 == 0) {
                                f++;
                                document.getElementById("filo").style.display='block';
                                document.getElementById("fil").style.background='rgba(20,113,143,0.8)';
                                document.getElementById("fil").style.padding='10px';
                                z += 1;
                            } else {
                                f++;
                                document.getElementById("filo").style.display='none';
                                document.getElementById("fil").style.background='transparent';
                                document.getElementById("fil").style.padding='0px';
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