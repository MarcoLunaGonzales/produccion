var mensajeJss= new function ()
{
    this.divRegistro=null;
    this.divModal=null;
    this.creado=false;
    this.eventoBoton=null;
    this.mostrar=function(mensajeTexto,tipoMensaje,evento)
    {
        this.eventoBoton=evento;
        this.valor=false;
        if(this.divRegistro==null)
        {
            this.divRegistro=document.createElement("center");
            this.divRegistro.id='registross';
            this.divRegistro.className="modalMensaje";
            this.divRegistro.align="center";
            this.divModal=document.createElement("div");
            this.divModal.className="formSuper";
            this.divModal.style.visibility='visible';
        }
        else
        {
            this.divModal.style.visibility='visible';
            this.divRegistro.style.visibility='visible';
        }
        this.divRegistro.innerHTML="<center><table cellpading='0' cellspacing='0' class='"+(tipoMensaje==1?"mensaje1":"")+(tipoMensaje==2?"mensajeAlerta":"")+(tipoMensaje==3?"mensajeConfirmacion":"")+"' ><thead><tr><td>"+(tipoMensaje==1?"Mensaje":"")+(tipoMensaje==2?"Alerta":"")+(tipoMensaje==3?"Confirmacion":"")+"</td></tr></thead>"+
                                    "<tbody><tr><td><span>"+mensajeTexto+"</span></td></tr>"+
                                    "<tr><td>"+
                                    (tipoMensaje==1||tipoMensaje==2?"<button onclick='mensajeJss.ocultarMensaje(true);'>Aceptar</button>":"")+
                                    (tipoMensaje==3?"<button onclick='mensajeJss.ocultarMensaje(true);'>SI</button><button onclick='mensajeJss.ocultarMensaje(false);'>NO</button>":"")+
                                    "</td></tr>"+
                                    "</tbody></table></center>";
        if(!this.creado)
        {
            document.body.appendChild(this.divModal);
            document.body.appendChild(this.divRegistro);
            this.creado=true;
        }
    }
    this.ocultarMensaje=function(estado)
    {
        
        if(this.eventoBoton!=null)this.eventoBoton(estado);
        this.divRegistro.style.visibility='hidden';
        this.divModal.style.visibility='hidden';
    }
}
function mensajeJs(mensaje)
{
    mensajeJss.mostrar(mensaje,1,null);
}
function mensajeJs(mensaje,evento)
{
    mensajeJss.mostrar(mensaje,1,evento);
}
function alertJs(mensaje)
{
    mensajeJss.mostrar(mensaje,2,null);
}
function alertJs(mensaje,evento)
{
    mensajeJss.mostrar(mensaje,2,evento);
}
function confirmJs(mensaje,evento)
{
    mensajeJss.mostrar(mensaje,3,evento);
}
function confirmJs(mensaje,evento)
{
    mensajeJss.mostrar(mensaje,3,evento);
}