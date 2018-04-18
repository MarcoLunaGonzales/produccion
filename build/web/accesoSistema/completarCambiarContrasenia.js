onerror = function(e){
                alert('Ocurrio un error');
                window.location.reload();
            }
function mostrarMensajeHint(mensaje,input)
{
    if(document.getElementById("mensajeHintSistema")==null)
    {
        var span=document.createElement("span");
        span.className='hint';
        span.id='mensajeHintSistema';
        input.parentNode.appendChild(span);
    }
    input.parentNode.style.position='relative';
    document.getElementById("mensajeHintSistema").style.left=input.offsetLeft;
    document.getElementById("mensajeHintSistema").style.top=input.offsetTop+18;
    document.getElementById("mensajeHintSistema").style.display='inline';
    document.getElementById("mensajeHintSistema").innerHTML=mensaje;
    try
    {
        if(document.getElementById("mensajeHintSistema").addEventListener){
            document.getElementById("mensajeHintSistema").addEventListener("click",function(){ocultarMensajeHint();},true);
            input.addEventListener("click",function(){ocultarMensajeHint();},true);
            input.addEventListener("change",function(){ocultarMensajeHint();},true);
            input.addEventListener("keypress",function(){ocultarMensajeHint();},true);
        }
        else
        {
            document.getElementById("mensajeHintSistema").attachEvent("onclick",function(){ocultarMensajeHint();});
            input.attachEvent("onclick",function(){ocultarMensajeHint();});
            input.attachEvent("onkeypress",function(){ocultarMensajeHint();});
            input.attachEvent("onchange",function(){ocultarMensajeHint();});
        }
    }
    catch(e){alert("datos no soportados favor comuniquese con sistemas "+e.toString());}
}
function ocultarMensajeHint()
{
    try
    {
        var mensaje=document.getElementById("mensajeHintSistema");
        mensaje.parentNode.removeChild(mensaje);
    }
    catch(e){}
}
function guardar_modificaciones(){
    var contraseniaNueva = document.getElementById("contraseniaNueva");
    var regex = /[a-z]/;
    if(!regex.test(contraseniaNueva.value)){
        mostrarMensajeHint('La nueva contraseña debe tener al menos una letra minuscula',contraseniaNueva);
        return false;
    }
    regex = /[A-Z]/;
    if(!regex.test(contraseniaNueva.value)){
        mostrarMensajeHint('La nueva contraseña debe tener al menos una letra mayuscula',contraseniaNueva);
        return false;
    }
    regex = /[0-9]/;
    if(!regex.test(contraseniaNueva.value)){
        mostrarMensajeHint('La nueva contraseña debe tener al menos un numero',contraseniaNueva);
        return false;
    }

    regex = /[-_$@.%#&*]/;
    if(!regex.test(contraseniaNueva.value)){
        mostrarMensajeHint('La nueva contraseña debe tener al menos uno de los siguientes caracteres: -_$@.%#&*',contraseniaNueva);
        return false;
    }

    if(contraseniaNueva.value != document.getElementById("contraseniaNuevaRepite").value){
        mostrarMensajeHint('La verificación de la nueva contraseña no coinciden',document.getElementById("contraseniaNuevaRepite"));
        return false;
    }

    if(contraseniaNueva.value.length < 6){
        mostrarMensajeHint('La contraseña nueva debe tener al menos 6 caracteres',contraseniaNueva);
        return false;
    }
    document.getElementById("formCompletarCambioContrasena").submit();
}