iniciarDateTime();
var tiempo=null;
function hora(hora,minutos,idInput)
{
    
    this.hora=hora;
    eval("document.getElementById('hora"+this.hora+"').className='celdaHoraTimeSelect';");
    this.minutos=minutos;
    if((parseInt(this.minutos)%5==0)||(parseInt(this.minutos)==59))
    {
        eval("document.getElementById('min"+this.minutos+"').className='celdaHoraTimeSelect';");
    }
    this.idInput=idInput;
    this.clear=function()
    {
        eval("document.getElementById('hora"+this.hora+"').className='celdaHoraTime';");
        if((parseInt(this.minutos)%5==0)||(parseInt(this.minutos)==59))
        {
            eval("document.getElementById('min"+this.minutos+"').className='celdaHoraTime';");
        }
    }
    this.asignarHora=function(hora)
    {
        eval("document.getElementById('hora"+this.hora+"').className='celdaHoraTime';");
        this.hora=hora;
        eval("document.getElementById('hora"+this.hora+"').className='celdaHoraTimeSelect';");
        this.insertarHoraInput();
    }
    this.asignarMinutos=function(minutos)
    {
        if((parseInt(this.minutos)%5==0)||(parseInt(this.minutos)==59))
        {
            eval("document.getElementById('min"+this.minutos+"').className='celdaHoraTime';");
        }
        this.minutos=minutos;
        eval("document.getElementById('min"+this.minutos+"').className='celdaHoraTimeSelect';");
        this.insertarHoraInput();
    }
    this.insertarHoraInput=function()
    {
        document.getElementById(this.idInput).value=this.hora+':'+this.minutos;
    }
}
function asignarHora(horaTexto)
{
    tiempo.asignarHora(horaTexto);
}
function asignarMinutos(textoMinutos)
{
    tiempo.asignarMinutos(textoMinutos);
}
function verificarHora(valor)
{
    var areglo=valor.split(":");
    if(areglo.length!=2)
    {
        return false;
    }
    if(isNaN(areglo[0][1])||isNaN(areglo[0][0])||isNaN(areglo[1][0])||isNaN(areglo[1][1])||(areglo[0].length!=2)||(areglo[1].length!=2))
    {
        return false;
    }
    if((parseInt(areglo[0])<0)||(parseInt(areglo[0])>23))
    {
        return false;
    }
    if((parseInt(areglo[1])<0)||(parseInt(areglo[1])>59))
    {
        return false;
    }

    return true;

}
function ocultarPanelRegistroHora()
{
    document.getElementById(tiempo.idInput).focus();
    document.getElementById(tiempo.idInput).blur();
    document.getElementById('panelTime').className='panelModalHide';
    document.getElementById('divAsignar').className='panelModalHide';
}
function seleccionarHora(input)
{
    document.getElementById('panelTime').className='panelModalVisible';
    document.getElementById('divAsignar').className='panelRegistroVisible';
    input.blur();
    if(verificarHora(input.value))
    {
        if(tiempo!=null)tiempo.clear();
        tiempo=new hora(input.value.split(':')[0],input.value.split(':')[1],input.id);
    }
    if(input.value=='')
    {
        if(tiempo!=null)tiempo.clear();
        tiempo=new hora('00','00',input.id);
    }

}
function iniciarDateTime()
{
    var  panelRegistro=document.createElement("div");
     panelRegistro.className='panelModalHide';
     panelRegistro.id='panelTime';
     panelRegistro.onclick=function(){ocultarPanelRegistroHora();}
     var divRegistro=document.createElement("div");
     divRegistro.className='panelModalHide';
     divRegistro.id='divAsignar';
     var tabla="<center>"+
                        " <table   class='tablaRegistro' cellpadding='10px' cellspacing='10px'>"+
                           "<tr><td class='celdaCabeceraTime' colspan='7' ><span style='width:1.5em'>Horas</span></td><td style='width:0.5em;background-color:#f5dbef'></td>"+
                           "<td class='celdaCabeceraTime' colspan='3' style='width:1.5em' ><span>Minutos</span></td></tr>"+
                           "<tr><td rowspan='2' width='1.7em' style='background-color:#f5dbef' id='timeBeforeMediumDay'>AM</td>";
     for(var i=0;i<6;i++)
     {
        tabla+="<td onclick=\"asignarHora('"+((i<10?'0':'')+i)+"');\" id='hora0"+i+"'  class='celdaHoraTime'>0"+i+"</td>";
     }
     tabla+="<td style='width:0.5em;background-color:#f5dbef'></td><td class='celdaHoraTime' onclick=\"asignarMinutos('00')\" id='min00' >00</td>"+
            " <td class='celdaHoraTime' id='min05' onclick=\"asignarMinutos('05')\" >05</td>"+
            "<td class='celdaHoraTime' id='min10' onclick=\"asignarMinutos('10')\">10</td></tr><tr>";
     for(var i=6;i<12;i++)
     {
        tabla+="<td onclick=\"asignarHora('"+((i<10?'0':'')+i)+"');\" id='hora"+((i<10?'0':'')+i)+"' class='celdaHoraTime'>"+(i<10?"0":"")+i+"</td>";
     }
     tabla+="<td style='width:0.5em;background-color:#f5dbef'></td>";
     for(var i=15;i<30;i+=5)
     {
        tabla+="<td class='celdaHoraTime' onclick=\"asignarMinutos('"+i+"')\" id='min"+i+"' >"+i+"</td>";
     }

     tabla+="</tr><tr><td rowspan='2' style='background-color:#f5dbef'>PM</td>";
     for(var i=12;i<18;i++)
     {
        tabla+="<td onclick=\"asignarHora('"+i+"');\" id='hora"+i+"' class='celdaHoraTime'>"+i+"</td>";
     }
     tabla+="<td style='width:0.5em;background-color:#f5dbef'></td>";
     for(var i=30;i<45;i+=5)
     {
        tabla+="<td class='celdaHoraTime' onclick=\"asignarMinutos('"+i+"')\" id='min"+i+"'>"+i+"</td>";
     }
     tabla+="</tr><tr>";
     for(var i=18;i<24;i++)
     {
        tabla+="<td onclick=\"asignarHora('"+i+"');\" id='hora"+i+"' class='celdaHoraTime'>"+i+"</td>";
     }
     tabla+="<td style='width:0.5em;background-color:#f5dbef'></td>";
     for(var i=45;i<60;i+=5)
     {
        tabla+="<td class='celdaHoraTime' onclick=\"asignarMinutos('"+i+"')\" id='min"+i+"'>"+i+"</td>" ;
     }
     tabla+="</tr><tr><td colspan='4' style='background-color:#f5dbef'></td>"+
            "<td colspan='3' style='background-color:#f5dbef'><button  class='buttonHIde'onclick='ocultarPanelRegistroHora();' >Aceptar</button></td>"+
            "<td colspan='3' style='background-color:#f5dbef'></td>"+
            "<td class='celdaHoraTime' onclick=\"asignarMinutos('59')\" id='min59'>59</td></tr></table><center>";
     divRegistro.innerHTML=tabla;

                           

     document.body.appendChild(divRegistro);
     document.body.appendChild(panelRegistro);
     
}