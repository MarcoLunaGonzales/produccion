var dateTimePicker=null;
var fechaActualDatePicker="";
var mesesDateTimePicker=['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
var diasDateTimePicker=['Dom','Lun','Mar','Mie','Jue','Vie','Sab'];
function fechaDateTime(fecha,idInput,fechaValida,fechaAnt,fechaPenUlt)
{
    this.fechaValida1=(fechaValida.getDate()>9?"":"0")+fechaValida.getDate()+"/"+(fechaValida.getMonth()>8?"":"0")+(fechaValida.getMonth()+1)+"/"+fechaValida.getFullYear();
    this.fechaValida2=(fechaAnt.getDate()>9?"":"0")+fechaAnt.getDate()+"/"+(fechaAnt.getMonth()>8?"":"0")+(fechaAnt.getMonth()+1)+"/"+fechaAnt.getFullYear();
    this.fechaValida3=(fechaPenUlt.getDate()>9?"":"0")+fechaPenUlt.getDate()+"/"+(fechaPenUlt.getMonth()>8?"":"0")+(fechaPenUlt.getMonth()+1)+"/"+fechaPenUlt.getFullYear();
    if(fecha!='')this.fechaInput=fecha;else this.fechaInput=(fechaValida.getDate()>9?"":"0")+fechaValida.getDate()+"/"+(fechaValida.getMonth()>8?"":"0")+(fechaValida.getMonth()+1)+"/"+fechaValida.getFullYear();
    this.recorrido=new Date(parseInt(this.fechaInput.split("/")[2]),parseInt(this.fechaInput.split("/")[1])-1,1,0,0,0,0);
    this.idInput=idInput;
    this.asignarFecha=function(fecha)
    {
        this.fechaInput=fecha;
        this.insertarFechaInput();
    }

    this.insertarFechaInput=function()
    {
        eval("document.getElementById('fechaDTP"+this.fechaInput+"').className='celdaHoraTimeSelect';");
        document.getElementById(this.idInput).value=this.fechaInput;
        document.getElementById(this.idInput).focus();
        document.getElementById(this.idInput).blur();
        document.getElementById('panelDatePicker').className='panelModalHide';
        document.getElementById('divAsignarDatePicker').className='panelModalHide';
    }
    this.siguienteMes=function()
    {
        this.recorrido.setDate(this.recorrido.getDate()+1);
        this.recorrido.setDate(1);
        this.drawPadSelection();
        return null;
    }
    this.fechaActualDatePicker=function()
    {
        this.recorrido.setDate(1);
        this.recorrido.setMonth(parseInt(this.fechaValida1.split("/")[1])-1);
        this.recorrido.setFullYear(parseInt(this.fechaValida1.split("/")[2]));
        this.drawPadSelection();
        return null;
    }
    this.anteriorMes=function()
    {
        this.recorrido.setDate(-1);
        this.recorrido.setDate(1);
        this.drawPadSelection();
        return null;
    }
    this.fechaAnterior=function(cantDias)
    {
        var fecha1=this.fechaValida1.split("/");
        var date=new Date(parseInt(fecha1[2]),(parseInt(fecha1[1])-1),(parseInt(fecha1[0])-cantDias),0,0,0,0);
        return ((date.getDate()>9?"":"0")+date.getDate()+"/"+(date.getMonth()>8?"":"0")+(date.getMonth()+1)+"/"+date.getFullYear());
    }
    this.drawPadSelection=function()
    {
        var tabla="<center>"+
                        " <table   class='tablaRegistro' cellpadding='4px' cellspacing='4px'>"+
                           "<tr><td style='width:0.5em;background-color:#f5dbef'></td><td class='celdaCabeceraTime' colspan='7' ><span style='width:1.5em'>"+mesesDateTimePicker[this.recorrido.getMonth()].toUpperCase()+" "+this.recorrido.getFullYear()+"</span></td><td style='width:0.5em;background-color:#f5dbef'></td>"+
                           "</tr>"+
                           "<tr><td style='width:0.5em;background-color:#f5dbef'></td>";
         for(var i=0;i<7;i++)
         {
             tabla+="<td  class='celdaCabeceraTime' style='padding-top: 0.1em !important;padding-bottom: 0.1em !important'>"+diasDateTimePicker[i]+"</td>";

         }
         tabla+="</tr><tr><td rowspan='7' class='celdaCabeceraTime' onclick='dateTimePicker.anteriorMes()' style='width:0.7em !important;padding:0px !important'><</td>";
         var ultimoDia=ultimoDiaDateTimePIcker(this.recorrido.getMonth(),this.recorrido.getFullYear());
         for(var i=0;i<this.recorrido.getDay();i++)
         {
             tabla+="<td>&nbsp;</td>";
         }
         var siguiente=false;
         for(var i=0;i<ultimoDia;i++)
         {
            var fechaRecorrido=(this.recorrido.getDate()>9?"":"0")+this.recorrido.getDate()+"/"+(this.recorrido.getMonth()>8?"":"0")+(this.recorrido.getMonth()+1)+"/"+this.recorrido.getFullYear();
            if(this.recorrido.getDay()==0&&(this.recorrido.getDate()!=1))
            {
                tabla+=(siguiente?"":"<td rowspan='7' class='celdaCabeceraTime' onclick='dateTimePicker.siguienteMes()' style='width:0.7em !important;padding:0px !important'>></td>")+"</tr><tr>";
                siguiente=true;
            }
            tabla+="<td  id='fechaDTP"+fechaRecorrido+"' class='celdaFechaInactiva'>"+this.recorrido.getDate()+"</td>";
            if(i!=(ultimoDia-1))
            {
                this.recorrido.setDate(this.recorrido.getDate()+1);
            }
            
            //tabla+="<td onclick=\"asignarFecha('"+((i<10?'0':'')+i)+"');\" id='hora"+((i<10?'0':'')+i)+"' class='celdaHoraTime'>"+(i<10?"0":"")+i+"</td>";
         }
         tabla+="</tr><tr><td colspan='7' align='center' style='text-align:center;background-color:#f5dbef'>"+
                " <button  class='buttonHIde'onclick='ocularDateTimePIckerJs();' style='width:40%' >Cancelar</button>"+
                "<button  class='buttonHIde'onclick='dateTimePicker.fechaActualDatePicker();' style='width:40%' >HOY</button></td></tr></table><center>";
           // console.log(this.fechaAnterior(3)+"-"+this.fechaValida1);
         document.getElementById("divAsignarDatePicker").innerHTML=tabla;
         if(document.getElementById('fechaDTP'+this.fechaValida1)!=null){document.getElementById('fechaDTP'+this.fechaValida1).className='celdaFechaTime';document.getElementById('fechaDTP'+this.fechaValida1).addEventListener('click',function(){asignarFecha(dateTimePicker.fechaValida1);},true);}
         if(document.getElementById('fechaDTP'+this.fechaValida2)!=null){document.getElementById('fechaDTP'+this.fechaValida2).className='celdaFechaTime';document.getElementById('fechaDTP'+this.fechaValida2).addEventListener('click',function(){asignarFecha(dateTimePicker.fechaValida2);},true);}
         //if(document.getElementById('fechaDTP'+this.fechaValida3)!=null){document.getElementById('fechaDTP'+this.fechaValida3).className='celdaFechaTime';document.getElementById('fechaDTP'+this.fechaValida3).addEventListener('click',function(){asignarFecha(dateTimePicker.fechaValida3);},true);}
         //if(document.getElementById('fechaDTP'+this.fechaAnterior(3))!=null){document.getElementById('fechaDTP'+this.fechaAnterior(3)).className='celdaFechaTime';document.getElementById('fechaDTP'+this.fechaAnterior(3)).addEventListener('click',function(){asignarFecha(dateTimePicker.fechaAnterior(3));},true);}
         //if(document.getElementById('fechaDTP'+this.fechaAnterior(4))!=null){document.getElementById('fechaDTP'+this.fechaAnterior(4)).className='celdaFechaTime';document.getElementById('fechaDTP'+this.fechaAnterior(4)).addEventListener('click',function(){asignarFecha(dateTimePicker.fechaAnterior(4));},true);}
         if(document.getElementById('fechaDTP'+this.fechaInput)!=null)document.getElementById('fechaDTP'+this.fechaInput).className='celdaFechaTimeSelect';
         
         
    }
    
    this.drawPadSelection();
    
}
function asignarFecha(dateTime)
{
    
    dateTimePicker.asignarFecha(dateTime);
}

function ocularDateTimePIckerJs()
{
    document.getElementById(dateTimePicker.idInput).focus();
    document.getElementById('panelDatePicker').className='panelModalHide';
    document.getElementById('divAsignarDatePicker').className='panelModalHide';
}
function seleccionarDatePickerJs(input)
{
    document.getElementById('panelDatePicker').className='panelModalVisible';
    document.getElementById('divAsignarDatePicker').className='panelRegistroVisible';
    input.blur();
    var fechaAnt=new Date(fechaActualDatePicker.getFullYear(),fechaActualDatePicker.getMonth(),fechaActualDatePicker.getDate(),0,0,0,0);
    fechaAnt.setDate(fechaAnt.getDate()-6);
    console.log("fecha anterior jj "+fechaAnt.toString());
    var fechaPenUlt=new Date(fechaActualDatePicker.getFullYear(),fechaActualDatePicker.getMonth(),fechaActualDatePicker.getDate(),0,0,0,0);
    fechaPenUlt.setDate(fechaPenUlt.getDate()-2);
    console.log("fecha penult jj "+fechaPenUlt.toString());
    dateTimePicker=new fechaDateTime(input.value,input.id,fechaActualDatePicker,fechaAnt,fechaPenUlt);
       
}
function ultimoDiaDateTimePIcker(month,year) {
    
      month+=1;
      switch (month) {
        case 1 : case 3 : case 5 : case 7 : case 8 : case 10 : case 12 : return 31;
        case 2 : return (year% 4 == 0) ? 29 : 28;
      }
   return 30;
}
function iniciarDatePicker(fechaActual)
{
    
    fechaActualDatePicker=new Date(parseInt(fechaActual.split("/")[2]),parseInt(fechaActual.split("/")[1])-1,parseInt(fechaActual.split("/")[0]),0,0,0,0);
     var  panelRegistro=document.createElement("div");
     panelRegistro.className='panelModalHide';
     panelRegistro.id='panelDatePicker';
     panelRegistro.onclick=function(){ocularDateTimePIckerJs();}
     var divRegistro=document.createElement("div");
     divRegistro.className='panelModalHide';
     divRegistro.id='divAsignarDatePicker';
     

                           

     document.body.appendChild(divRegistro);
     document.body.appendChild(panelRegistro);
     
}