var dateTimePicker=null;
var fechaActualDatePicker="";
var mesesDateTimePicker=['enero','febrero','marzo','abril','mayo','junio','julio','agosto','septiembre','octubre','noviembre','diciembre'];
var diasDateTimePicker=['Dom','Lun','Mar','Mie','Jue','Vie','Sab'];
fechaActualDatePicker=new Date();
function fechaDateTime()
{

    this.fechaInput=document.getElementById("form1:fechaFiltro").value;
    this.recorrido=new Date(parseInt(this.fechaInput.split("/")[2]),parseInt(this.fechaInput.split("/")[1])-1,1,0,0,0,0);
    this.asignarCoorDenadas=function(idTabla)
    {
        var detalleBody=document.getElementsByName("tbodyDetalle");
        for(var i=0;i<detalleBody.length;i++)
        {

            for(var j=0;j<7;j++) {
                detalleBody[i].rows[0].cells[j].innerHTML = '';
            }
        }
        var tablaDatos=document.getElementById(idTabla).getElementsByTagName("tbody")[0];
        for(var i=0;i<tablaDatos.rows.length;i++)
        {
            var tabla=document.getElementById(tablaDatos.rows[i].cells[1].getElementsByTagName("input")[0].value).parentNode.parentNode.parentNode;
            var index=document.getElementById(tablaDatos.rows[i].cells[1].getElementsByTagName("input")[0].value).cellIndex;
            var body=tabla.getElementsByTagName('tbody')[0];
            var link=document.createElement("a");
            link.className=tablaDatos.rows[i].cells[5].getElementsByTagName("span")[0].innerHTML+' fc-day-grid-event fc-h-event fc-event fc-not-start fc-end fc-draggable fc-resizable';
            link.innerHTML=tablaDatos.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML;
            body.rows[0].cells[index].appendChild(link);
        }


    }
    this.cronogramaMes=function()
    {
        this.updatePadSeleccion();
        document.getElementById("buttonViewMonth").className='fc-month-button fc-button fc-state-default fc-corner-left fc-state-active';
        document.getElementById("buttonViewMan").className='fc-basicWeek-button fc-button fc-state-default fc-corner-right';
        
    }
    this.cronogramaMantenimiento=function()
    {
        document.getElementById("buttonViewMonth").className='fc-month-button fc-button fc-state-default fc-corner-left ';
        document.getElementById("buttonViewMan").className='fc-basicWeek-button fc-button fc-state-default fc-corner-right fc-state-active ';
        document.getElementById("divContainerCalendar").innerHTML='<table class="tablaMantenimiento" cellspacing="0" cellpadding="0">'+document.getElementById("form1:dataMaquinariaMantenimiento").innerHTML+'</table>';
    }

    this.diaActual=function()
    {
        this.recorrido=new Date();
        this.recorrido.setDate(1);
        var fechaRecorrido=(this.recorrido.getDate()>9?"":"0")+this.recorrido.getDate()+"/"+(this.recorrido.getMonth()>8?"":"0")+(this.recorrido.getMonth()+1)+"/"+this.recorrido.getFullYear();
        document.getElementById("form1:fechaFiltro").value=fechaRecorrido;
        this.fechaInput=document.getElementById("form1:fechaFiltro").value;
        cambioMes();
        return null;
    }
    this.siguienteMes=function()
    {
        this.recorrido.setDate(this.recorrido.getDate()+1);
        this.recorrido.setDate(1);
        var fechaRecorrido=(this.recorrido.getDate()>9?"":"0")+this.recorrido.getDate()+"/"+(this.recorrido.getMonth()>8?"":"0")+(this.recorrido.getMonth()+1)+"/"+this.recorrido.getFullYear();
        document.getElementById("form1:fechaFiltro").value=fechaRecorrido;
        this.fechaInput=document.getElementById("form1:fechaFiltro").value;
        cambioMes();
        return null;
    }
    this.updatePadSeleccion=function()
    {
        this.drawPadSelection();
        cronograma.asignarCoorDenadas('form1:dataMantenimientoPlanificado');
        return null;
    }
    this.anteriorMes=function()
    {
        this.recorrido.setDate(-1);
        this.recorrido.setDate(1);
        var fechaRecorrido=(this.recorrido.getDate()>9?"":"0")+this.recorrido.getDate()+"/"+(this.recorrido.getMonth()>8?"":"0")+(this.recorrido.getMonth()+1)+"/"+this.recorrido.getFullYear();
        document.getElementById("form1:fechaFiltro").value=fechaRecorrido;
        this.fechaInput=document.getElementById("form1:fechaFiltro").value;
        cambioMes();
        return null;
    }

    this.drawPadSelection=function()
    {
        var divCalendar=document.getElementById("form1:divCalendar");
        divCalendar.innerHTML="";
        divCalendar.className='fc fc-ltr fc-unthemed';
        var divHeader=document.createElement("div");
        divHeader.className='fc-toolbar';
        divHeader.id='divHeaderCalendar';
        divCalendar.appendChild(divHeader);
        var div2=document.createElement("div");
        div2.className='fc-view-container';
        var divContainer=document.createElement("div");
        divContainer.className='fc-view fc-month-view fc-basic-view';
        divContainer.id='divContainerCalendar';
        document.body.appendChild(divCalendar);
        divCalendar.appendChild(div2);

        div2.appendChild(divContainer);
        var divFooter=document.createElement("div");
        divFooter.style.textAlign="left";
        divFooter.style.padding="0.7em";
        divFooter.className='fc-toolbar';
        divFooter.id='divFooterCalendar';
        divFooter.innerHTML='<b>Nota:</b> <table class="tablaNota" cellpadding="0" cellspacing="0"><tr><td class="S">S:Semanal</td><td class="Q">Q:Quincenal</td><td class="M">M:Mensual</td><td class="B">B:Bimensual</td><td class="T">T:Trimestral</td><td class="C">C:Cuatrimestral</td><td class="SE">SE:Semestral</td><td class="A">A:Anual</td></tr></table>';
        divCalendar.appendChild(divFooter);

        this.recorrido=new Date(parseInt(this.fechaInput.split("/")[2]),parseInt(this.fechaInput.split("/")[1])-1,1,0,0,0,0);
        var detalleTbody="<tbody name='tbodyDetalle'>"+
            "<tr><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/></tr>"+
            "<tr><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/></tr>"+
            "<tr><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/><td class='fc-event-container'/></tr>"+
            "</tbody>";
        var detalleRegistro="<center>"+
            "<table>" +
            "<thead class='fc-head'><tr><td class='fc-head-container fc-widget-header fc-header-td'>"+
            "<div class='fc-row fc-widget-header'><table><thead><tr>";
        for(var i=0;i<7;i++)
        {
            detalleRegistro+="<th class='fc-day-header fc-widget-header fc-sun'>"+diasDateTimePicker[i]+"</th>";
        }
        detalleRegistro+="</tr></thead></table></div>"+
            " </td></tr></thead>";
        detalleRegistro+="<tbody class='fc-body'>"+
            "<tr><td class='fc-widget-content'><div class='fc-scroller fc-day-grid-container' style='overflow: hidden; height: 450px;'>"+
            "<div class='fc-day-grid fc-unselectable'>";
        detalleRegistro+="<div class='fc-row fc-week fc-widget-content fc-rigid' style='height: 90px;'><div class='fc-bg'><table><tbody><tr>";
        var ultimoDia=ultimoDiaDateTimePIcker(this.recorrido.getMonth(),this.recorrido.getFullYear());
        var detalleDias="<div class='fc-content-skeleton'><table><thead><tr>";
        for(var i=0;i<this.recorrido.getDay();i++)
        {
            detalleRegistro+="<td class='fc-day fc-widget-content fc-sun fc-past'>&nbsp;</td>";
            detalleDias+="<td class='fc-day-number fc-sun fc-past'>&nbsp;</td>";
        }
        var siguiente=false;
        var diaIndex=0;
        for(var i=0;i<ultimoDia;i++)
        {
            var fechaRecorrido=(this.recorrido.getDate()>9?"":"0")+this.recorrido.getDate()+"/"+(this.recorrido.getMonth()>8?"":"0")+(this.recorrido.getMonth()+1)+"/"+this.recorrido.getFullYear();
            diaIndex=this.recorrido.getDay();
            if(this.recorrido.getDay()==0&&(this.recorrido.getDate()!=1))
            {
                detalleRegistro+="</tr></tbody></table></div>"+detalleDias+"</tr></thead>"+detalleTbody+"</table></div></div><div class='fc-row fc-week fc-widget-content fc-rigid' style='height: 90px;'><div class='fc-bg'><table><tbody><tr>";
                detalleDias="<div class='fc-content-skeleton'><table><thead><tr>";
                //detalleDias+=(siguiente?"":"<td rowspan='7' class='celdaCabeceraTime' onclick='dateTimePicker.siguienteMes()' style='width:0.7em !important;padding:0px !important'>></td>")+"</tr><tr>";
                siguiente=true;
            }
            if(this.recorrido.getDate()==(new Date()).getDate()&&this.recorrido.getMonth()==(new Date()).getMonth()&&this.recorrido.getFullYear()==(new Date()).getFullYear())
            {
                detalleRegistro+="<td class='fc-day fc-widget-content fc-wed fc-today fc-state-highlight'></td>";
            }
            else {
                detalleRegistro += "<td class='fc-day fc-widget-content fc-sun fc-past'></td>";
            }
            detalleDias+="<td class='fc-day-number fc-sun fc-past' id='"+fechaRecorrido+"'><div class='buttonMas'><a onclick='agregarFechaMantenimiento(\""+fechaRecorrido+"\")'>+</a></div>"+this.recorrido.getDate()+"</td>";
            //detalleDias+="<td  id='fechaDTP"+fechaRecorrido+"' class='celdaFechaInactiva'>"+this.recorrido.getDate()+"</td>";
            if(i!=(ultimoDia-1))
            {
                this.recorrido.setDate(this.recorrido.getDate()+1);
            }
        }
        for(var i=diaIndex;i<6;i++)
        {
            detalleRegistro+="<td class='fc-day fc-widget-content fc-sun fc-past'>&nbsp;</td>";
            detalleDias+="<td class='fc-day-number fc-sun fc-past'>&nbsp;</td>";
        }

        detalleDias+="</tr></thead>"+detalleTbody+"<table></div>";
        //terminando dibujo 1
        detalleRegistro+="</tr></tbody></table></div>";
        detalleRegistro+=detalleDias;
        detalleRegistro+="</div>"+
            "</div></td></tr></tbody>";
        document.getElementById("divContainerCalendar").innerHTML=detalleRegistro;
        document.getElementById("divHeaderCalendar").innerHTML="<div class='fc-clear' style='font-size:2em;font-weight: bold'>PLAN DE MANTENIMIENTO LIQUIDOS ESTERILES</div>"+
            "<div class='fc-left'>"+
            "<div class='fc-button-group'>"+
            "<button type='button' class='fc-prev-button fc-button fc-state-default fc-corner-left' onclick='cronograma.anteriorMes()'>"+
            "<span class='fc-icon fc-icon-left-single-arrow'></span>"+"" +
            "</button>"+
            "<button type='button' class='fc-next-button fc-button fc-state-default fc-corner-right' onclick='cronograma.siguienteMes()'>"+
            "<span class='fc-icon fc-icon-right-single-arrow'></span>"+
            "</button>"+
            "</div>"+
            "<button type='button' class='fc-today-button fc-button fc-state-default fc-corner-left fc-corner-right' onclick='cronograma.diaActual()' >HOY</button>"+
            "</div>"+
            "<div class='fc-right'>" +
            "<div class='fc-button-group'>"+
            "<button type='button' id='buttonViewMonth' class='fc-month-button fc-button fc-state-default fc-corner-left fc-state-active' onclick='cronograma.cronogramaMes()'>Mensual</button>"+
            "<button type='button' id='buttonViewMan' class='fc-basicWeek-button fc-button fc-state-default fc-corner-right' onclick='cronograma.cronogramaMantenimiento()'>Mantenimiento</button>"+
            /*"<button type='button' class='fc-basicDay-button fc-button fc-state-default fc-corner-right'>day</button>"+*/
            "</div>"+
            "</div>"+
            "<div class='fc-center'>"+
            "<h2>"+mesesDateTimePicker[this.recorrido.getMonth()].toUpperCase()+" "+this.recorrido.getFullYear()+"</h2>"+
            "</div>"+
            "<div class='fc-clear'></div>";
    }

    this.drawPadSelection();

}

function agregarFechaMantenimiento(fechaMantenimiento)
{
    document.getElementById("form1:fechaRegistroMantenimiento").value=fechaMantenimiento;
    agregarMantenimiento();
}
function ultimoDiaDateTimePIcker(month,year) {

    month+=1;
    switch (month) {
        case 1 : case 3 : case 5 : case 7 : case 8 : case 10 : case 12 : return 31;
        case 2 : return (year% 4 == 0) ? 29 : 28;
    }
    return 30;
}
var cronograma;
window.onload=function(){
    cronograma=new fechaDateTime();
    cronograma.asignarCoorDenadas('form1:dataMantenimientoPlanificado');}