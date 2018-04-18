
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #b0f3b0;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }
                .pendiente
                {
                    background-color:#90EE90;
                }
                .cabecera{
                    background-image:none;
                    background-color:#670d55 !important;
                    height: 22px;
                    color: #ffffff;
                    font-family: Verdana, Arial, Helvetica, sans-serif;
                    font-size: 12px;
                    font-weight:bold;
                }
                a
                {
                    font-weight: bold;
                    color: #4146ac;
                }
            </style>
          <script>
                function getCodigo(cod_maquina,codigo){
                 //  alert(codigo);
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
                }

                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                     }
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }

                   }

                }
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }

               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{

                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;

                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;

                }
           }

           function validarSeleccion(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }
        function verManteminiento(cod_maquina,codigo){
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
        }

        function seleccionarAsignado(valorCheck)
                {
                    //alert(document.getElementById('form2:asignado:0').checked);
                    //if(valorCheck=="interno"){
                    alert(valorCheck.checked +" "+ valorCheck.value);
                    if(valorCheck.checked){
                        document.getElementById('form2:selectPersonal').disabled= false;
                        document.getElementById('form2:selectProovedor').disabled= true;
                    }else{
                        document.getElementById('form2:selectPersonal').disabled= true;
                        document.getElementById('form2:selectProovedor').disabled=false;
                    }
                }
        function seleccionarAsignado1(valorCheck)
                {
                    alert(valorCheck.checked +" "+ valorCheck.value);
                    if(valorCheck.checked){
                        document.getElementById('form3:selectPersonal').disabled= false;
                        document.getElementById('form3:selectProovedor').disabled= true;
                    }else{
                        document.getElementById('form3:selectPersonal').disabled= true;
                        document.getElementById('form3:selectProovedor').disabled=false;
                    }
                }
         function seleccionarAsignado2()
                {
                    if(document.getElementById('form2:asignado:0').checked){
                        document.getElementById('form2:selectPersonal').disabled= false;
                        document.getElementById('form2:selectProovedor').disabled= true;
                    }
                    if(document.getElementById('form2:asignado:1').checked){
                        document.getElementById('form2:selectPersonal').disabled= true;
                        document.getElementById('form2:selectProovedor').disabled=false;
                    }
                }
          function seleccionarAsignado3()
                {
                    if(document.getElementById('form3:asignado:0').checked){
                        document.getElementById('form3:selectPersonal').disabled= false;
                        document.getElementById('form3:selectProovedor').disabled= true;
                    }
                    if(document.getElementById('form3:asignado:1').checked){
                        document.getElementById('form3:selectPersonal').disabled= true;
                        document.getElementById('form3:selectProovedor').disabled=false;
                    }
                }
              function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
           function getNumeroDehoras(fechaIni,fechaFin)
           {

                if(fechaIni.length==16&&fechaFin.length==16)
                {


                var fec=fechaIni.split(" ");
                var d1=fec[0].split("/");
                var h1=fec[1].split(":");
                var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

                 var de2 = fechaFin.split(" ");

                 var d2=de2[0].split("/");
                 var h2=de2[1].split(":");

                 var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
                 var fin = dat2.getTime() - dat1.getTime();
                 var dias=0;
                 if(dat1!='NaN'&& dat2!='Nan')
                 {
                    var dias =redondeo2decimales(fin / (1000 * 60 * 60));
                 }


                return dias;
                }
                return 0;
            }
            function calcularDiferenciaFechas(celda)
            {
                
                var fecha1=celda.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[2].getElementsByTagName('input')[1].value;
                var fecha2=celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+celda.parentNode.parentNode.cells[3].getElementsByTagName('input')[1].value;
                var celdaHorasExtra=celda.parentNode.parentNode.cells[9].getElementsByTagName("input")[0].checked;
                var nroHoras=getNumeroDehoras(fecha1,fecha2);
                celda.parentNode.parentNode.cells[(celdaHorasExtra?5:4)].getElementsByTagName('input')[0].value=nroHoras;
                celda.parentNode.parentNode.cells[(celdaHorasExtra?5:4)].getElementsByTagName('span')[0].innerHTML=nroHoras;
                celda.parentNode.parentNode.cells[(celdaHorasExtra?4:5)].getElementsByTagName('input')[0].value=0;
                celda.parentNode.parentNode.cells[(celdaHorasExtra?4:5)].getElementsByTagName('span')[0].innerHTML=0;
                celda.parentNode.parentNode.cells[5].getElementsByTagName('input')[0].style.visibility=(celdaHorasExtra?'hidden':'');
                celda.parentNode.parentNode.cells[5].getElementsByTagName('span')[0].style.visibility=(celdaHorasExtra?'':'hidden');
                
            }
            function calcularDiferenciaFechas1()
            {
                var fecha1=document.getElementById("form9:fechaInicioEditar1").value+' '+document.getElementById("form9:horaInicioEditar1") .value;
                var fecha2=document.getElementById("form9:fechaFinalEditar1").value+' '+document.getElementById("form9:horaFinalEditar1") .value;
                document.getElementById("form9:cantidadHoras1").value=getNumeroDehoras(fecha1,fecha2);
                document.getElementById("form9:spanHoras1").innerHTML=document.getElementById("form9:cantidadHoras1").value+' horas';
            }

            function validarFecha(input)
            {
                if(!validaFechaDDMMAAAA(input.value))
                  {
                      alert("fecha invalida");
                       input.focus();
                       return false;
                  }
            }
            function validarHora(input)
            {
                var hm=input.value.split(":");
                if(hm.length==2)
                    {
                        if(parseInt(hm[0])>23||parseInt(hm[0])<0)
                            {
                                alert("hora invalida");
                                input.focus();
                                return false;
                            }
                        if(parseInt(hm[1])>59||parseInt(hm[1])<0)
                            {
                                alert("hora invalida");
                                input.focus();
                                return false;
                            }
                    }
                    else
                    {
                       alert("hora invalida");
                       input.focus();
                       return false;
                    }
            }

            function validaFechaDDMMAAAA(fecha){
                        var dtCh= "/";
                        var minYear=1900;
                        var maxYear=2100;
                        function isInteger(s){
                            var i;
                            for (i = 0; i < s.length; i++){
                                var c = s.charAt(i);
                                if (((c < "0") || (c > "9"))) return false;
                            }
                            return true;
                        }
                        function stripCharsInBag(s, bag){
                            var i;
                            var returnString = "";
                            for (i = 0; i < s.length; i++){
                                var c = s.charAt(i);
                                if (bag.indexOf(c) == -1) returnString += c;
                            }
                            return returnString;
                        }
                        function daysInFebruary (year){
                            return (((year % 4 == 0) && ( (!(year % 100 == 0)) || (year % 400 == 0))) ? 29 : 28 );
                        }
                        function DaysArray(n) {
                            for (var i = 1; i <= n; i++) {
                                this[i] = 31
                                if (i==4 || i==6 || i==9 || i==11) {this[i] = 30}
                                if (i==2) {this[i] = 29}
                            }
                            return this
                        }
                        function isDate(dtStr){
                            var daysInMonth = DaysArray(12)
                            var pos1=dtStr.indexOf(dtCh)
                            var pos2=dtStr.indexOf(dtCh,pos1+1)
                            var strDay=dtStr.substring(0,pos1)
                            var strMonth=dtStr.substring(pos1+1,pos2)
                            var strYear=dtStr.substring(pos2+1)
                            strYr=strYear
                            if (strDay.charAt(0)=="0" && strDay.length>1) strDay=strDay.substring(1)
                            if (strMonth.charAt(0)=="0" && strMonth.length>1) strMonth=strMonth.substring(1)
                            for (var i = 1; i <= 3; i++) {
                                if (strYr.charAt(0)=="0" && strYr.length>1) strYr=strYr.substring(1)
                            }
                            month=parseInt(strMonth)
                            day=parseInt(strDay)
                            year=parseInt(strYr)
                            if (pos1==-1 || pos2==-1){
                                return false
                            }
                            if (strMonth.length<1 || month<1 || month>12){
                                return false
                            }
                            if (strDay.length<1 || day<1 || day>31 || (month==2 && day>daysInFebruary(year)) || day > daysInMonth[month]){
                                return false
                            }
                            if (strYear.length != 4 || year==0 || year<minYear || year>maxYear){
                                return false
                            }
                            if (dtStr.indexOf(dtCh,pos2+1)!=-1 || isInteger(stripCharsInBag(dtStr, dtCh))==false){
                                return false
                            }
                            return true
                        }
                        if(isDate(fecha)){
                            return true;
                        }else{
                            return false;
                        }
                    }
                    function cerrarOT()
                    {
                        var cerrar=document.getElementById('form9:cerrarOT');
                        if(cerrar!=null)
                        {
                            if(cerrar.checked)
                                {
                                    if(confirm('Esta seguro de cerrar la Orden de Trabajo, las tareas realizadas por el personal tambien se actualizaran a estado terminado?')==true)
                                        {
                                            return true;
                                        }
                                    else
                                        {
                                            return false;
                                        }
                                }
                        }
                        return true;
                    }
                    function asignarNombre()
                    {
                        var nombre=document.getElementById("form11:nombrePersonal");
                        if (nombre!=null)
                            {
                                var select=document.getElementById("form11:codPersonal");
                                nombre.value=select.options[select.selectedIndex].innerHTML;
                            }
                    }
                      A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }

       </script>
        </head>
        <body >
            
            
            
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.cargarPersonalSolicitudMantenimiento_action}"  />
                    
                    <h3 align="center">Ordenes de Trabajo</h3>
                    <h3 align="center">Seguimiento por Técnico</h3>
                    
                        
                        <a4j:jsFunction action="#{ManagedSeguimientoSolicitudMantenimiento.onFechachange_action}" reRender="dataSolicitudMantenimiento" name="fechasChange"/>
                        <rich:calendar value="#{ManagedSeguimientoSolicitudMantenimiento.fechaIniciofiltro}" styleClass="inputText" datePattern="dd/MM/yyyy" oncollapse="fechasChange();return true;">
                            
                        </rich:calendar>
                        <center><table><tr><td><span class="outputText2" style="font-weight:bold">Tareas pendientes</span></td>
                        <td style="width:60px" class="pendiente"></td><tr></table></center>
                        <%--rich:calendar value="#{ManagedSeguimientoSolicitudMantenimiento.fechaFinalFiltro}" styleClass="inputText" datePattern="dd/MM/yyyy" oncollapse="fechasChange();return true;">
                            
                        </rich:calendar--%>
                            
                        <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudesMatenimientoPersonalList}"
                                    var="data" id="dataSolicitudMantenimiento"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="cabecera" >
                         <f:facet name="header">
                             <rich:columnGroup>
                                 <rich:column rowspan="2">
                                     <h:outputText value=""  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Técnico"  />
                                 </rich:column>
                                 <rich:column colspan="3">
                                     <h:outputText value="Turno"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Nro O.T." />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Area"  />
                                 </rich:column>
                                 <rich:column rowspan="2" >
                                     <h:outputText value="Tipo de Trabajo"  />
                                 </rich:column>
                                 
                                 <rich:column rowspan="2">
                                     <h:outputText value="Maquinaria"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Instalación"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Obs. Solicitud"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Trabajo Realizado"  />
                                 </rich:column>
                                 <rich:column colspan="2" >
                                     <h:outputText value="Repuestos"  />
                                 </rich:column>
                                 <rich:column colspan="2" >
                                     <h:outputText value="Trabajo Terminado"  />
                                 </rich:column>
                                 <rich:column colspan="2" >
                                     <h:outputText value="Duración"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Horas Extra"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Horas Normal"  />
                                 </rich:column>
                                 <rich:column rowspan="2">
                                     <h:outputText value="Horas Extra"  />
                                 </rich:column>

                                 <rich:column rowspan="2">
                                     <h:outputText value="TOTAL HORAS"  />
                                 </rich:column>
                                 <rich:column breakBefore="true" styleClass="subHeaderTableClass">
                                     <h:outputText value="1"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="2"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="3"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="SI"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="NO"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="SI"  />
                                 </rich:column>
                                 <rich:column  styleClass="subHeaderTableClass">
                                     <h:outputText value="NO"  />
                                 </rich:column>
                                  <rich:column styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Inicial"  />
                                 </rich:column>
                                 <rich:column styleClass="subHeaderTableClass">
                                     <h:outputText value="Fecha Final"  />
                                 </rich:column>
                             </rich:columnGroup>
                             
                                 
                             
                         </f:facet>

             
                        
                        <rich:subTable var="sub" value="#{data.solicitudMantenimientoDetalleTareasList}" rowKeyVar="rowkey">
                            
                            <rich:column rowspan="#{data.cantidadOrdenesTrabajo}"  rendered="#{rowkey eq 0}">
                                    <h:selectBooleanCheckbox value="#{data.checked}" />
                                </rich:column>

                                <rich:column rowspan="#{data.cantidadOrdenesTrabajo}" rendered="#{rowkey eq 0}" >
                                    <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.agregarOrdenTrabajoPersonal}" timeout="7200"
                                    oncomplete="Richfaces.showModalPanel('panelAsociarOT')" reRender="contenidoAsociarOT">
                                        <f:param name="codPersonal" value="#{data.personal.codPersonal}"/>
                                        <f:param name="nombrePersonal" value="#{data.personal.nombrePersonal}"/>
                                        <h:outputText value="#{data.personal.nombrePersonal}" styleClass="outputText2"  />
                                    </a4j:commandLink>
                                </rich:column >

                                <rich:column styleClass="#{sub.colorFila}">
                                    <h:outputText value="X"  rendered="#{sub.turno eq 1}"/>
                                </rich:column >
                                <rich:column styleClass="#{sub.colorFila}">
                                    <h:outputText value="X"  rendered="#{sub.turno eq 2}"/>
                                </rich:column >
                                <rich:column styleClass="#{sub.colorFila}">
                                    <h:outputText value="X"  rendered="#{sub.turno eq 3}"/>
                                </rich:column >

                            <rich:column styleClass="#{sub.colorFila}">
                                <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.seleccionarTrabajoAction}" timeout="7200"
                                oncomplete="Richfaces.showModalPanel('panelSeguimiento')" reRender="contenidoSeguimiento">
                                    <f:param name="codSolicitud" value="#{sub.solicitudMantenimiento.codSolicitudMantenimiento}"/>
                                    <f:param name="codPersonal" value="#{data.personal.codPersonal}"/>
                                    <f:param name="nombrePersonal" value="#{data.personal.nombrePersonal}"/>
                                    <f:param name="codTipoTarea" value="#{sub.tiposTarea.codTipoTarea}"/>
                                    <f:param name="colorFila" value="#{sub.colorFila}"/>
                                    <h:outputText value="#{sub.solicitudMantenimiento.nroOrdenTrabajo}"  />
                                </a4j:commandLink>
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.solicitudMantenimiento.areasEmpresa.nombreAreaEmpresa}"  />
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.tiposTarea.nombreTipoTarea}"  />
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.solicitudMantenimiento.maquinaria.nombreMaquina}"  />
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.solicitudMantenimiento.areasInstalaciones.nombreAreaInstalacion}"  />
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.solicitudMantenimiento.obsSolicitudMantenimiento}"  />
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.descripcion}"  />
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="X"  rendered="#{sub.repuestos && sub.fechaInicial!=null}" title="Con Repuesto"/>
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}" title="#{sub.colorFila eq ''?'':'Tarea Pendiente'}">
                                <h:outputText value="X"  rendered="#{!sub.repuestos && sub.fechaInicial!=null}" title="Sin Repuesto"/>
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="X"  rendered="#{sub.terminado && sub.fechaInicial!=null}"/>
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="X"  rendered="#{!sub.terminado && sub.fechaInicial!=null}"/>
                            </rich:column >
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.fechaInicial}" >
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.fechaFinal}" >
                                    <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.registroHorasExtra?'HE':'HO'}" rendered="#{sub.fechaInicial!=null}"/>
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.horasHombre}" rendered="#{sub.fechaInicial!=null}">
                                    <f:convertNumber pattern="#0.00" locale="en"/>
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="#{sub.colorFila}">
                                <h:outputText value="#{sub.horasExtra}" rendered="#{sub.fechaInicial!=null}">
                                    <f:convertNumber pattern="#0.00" locale="en"/>
                                </h:outputText>
                            </rich:column>
                             <rich:column rowspan="#{data.cantidadOrdenesTrabajo}" rendered="#{rowkey eq 0}">
                                    <h:outputText value="#{data.horasHombre}"  >
                                        <f:convertNumber pattern="#0.00" locale="en"/>
                                    </h:outputText>
                              </rich:column >
                              <rich:column style="height:12px;background-color:#cccccc" breakBefore="true" styleClass="subHeaderTableClass" colspan="21"  rendered="#{rowkey eq (data.cantidadOrdenesTrabajo-1)}">

                                    </rich:column>

                            </rich:subTable>
                       
                    </rich:dataTable>
                    <br>
                    
                    <a4j:commandButton value="Agregar Tecnico"   styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.agregarTecnicoOrdenTrabajo}" timeout="7200"
                    oncomplete="Richfaces.showModalPanel('panelAsociarOT')" reRender="contenidoAsociarOT" />
                    
                </div>
                
            </a4j:form>
             <rich:modalPanel id="panelSeguimiento"  minHeight="470"  minWidth="1000"
                                     height="470" width="1000"
                                     zindex="200"
                                     headerClass="cabecera"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registrar tareas realizadas"/>
                        </f:facet>
                        <a4j:form id="form9">
                        <h:panelGroup id="contenidoSeguimiento">
                                <center>
                                    <rich:panel headerClass="cabecera">
                                    <f:facet name="header">
                                        <h:outputText value="Detalles de la Orden de Trabajo" styleClass="outputText2"/>
                                    </f:facet>

                                        <h:panelGrid columns="6" styleClass="navegadorTabla" >
                                            <h:outputText  value="TECNICO" styleClass="outputTextBold" />
                                            <h:outputText styleClass="outputTextBold" value="::" />
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.personal.nombrePersonal}" styleClass="outputText2"  />
                                            <h:outputText  value="Nro O.T" styleClass="outputTextBold"/>
                                            <h:outputText styleClass="outputTextBold" value="::"  />
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.nroOrdenTrabajo}" styleClass="outputText2"  />
                                            <h:outputText  value="AREA EMPRESA" styleClass="outputTextBold" />
                                            <h:outputText styleClass="outputTextBold" value="::"  />
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"  />
                                            <h:outputText  value="INSTALACION" styleClass="outputTextBold"  />
                                            <h:outputText styleClass="outputTextBold" value="::" />
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"  />
                                            <h:outputText  value="MAQUINA" styleClass="outputTextBold"/>
                                            <h:outputText styleClass="outputTextBold" value="::"/>
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"  />
                                            <h:outputText styleClass="outputTextBold" value="Estado O.T."  />
                                            <h:outputText styleClass="outputTextBold" value="::"  />
                                            <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                                            <h:outputText  value="CERRAR O.T." styleClass="outputText2"  style="font-weight:bold"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                            <h:selectBooleanCheckbox value="#{ManagedSeguimientoSolicitudMantenimiento.cerrarOT}" id="cerrarOT"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                        </h:panelGrid>
                                </rich:panel>
                                <br/>
                                <div style="overflow:auto;height:250px">
                                <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.seguimientoSolicitudesPersonalList}"
                                    var="data" id="dataDetalle"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="cabecera" >
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value=""/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                                        </rich:column>
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Trabajo Realizado"/>
                                            </f:facet>
                                            <h:inputText value="#{data.descripcion}" styleClass="inputText"/>
                                        </rich:column>
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Inicio"/>
                                            </f:facet>
                                            <h:inputText value="#{data.fechaInicial}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                            <h:inputText value="#{data.horaInicial}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Final"/>
                                            </f:facet>
                                            <h:inputText value="#{data.fechaFinal}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                            <h:inputText value="#{data.horaFinal}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                      <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Horas Hombre"/>
                                            </f:facet>
                                            <h:outputText  styleClass="outputText2" value="#{data.horasHombre}"><f:convertNumber pattern="#0.00" locale="en"/> </h:outputText>
                                            <h:inputHidden value="#{data.horasHombre}"/>
                                        </rich:column>
                                       <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Horas Extra"/>
                                            </f:facet>
                                            <center>
                                            <h:inputText value="#{data.horasExtra}" styleClass="inputText" size="5" style="#{data.registroHorasExtra?'visibility:hidden':''}"/>
                                            <h:outputText value="#{data.horasExtra}" escape="false" styleClass="outputText2" style=" width:5em;margin-top:-1.5em;#{data.registroHorasExtra?'':'visibility:hidden'}"/>
                                            </center>
                                        </rich:column>
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Tarea"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.tiposTarea.codTipoTarea}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tiposTareasList}"/>
                                            </h:selectOneMenu>
                                            
                                        </rich:column>
                                        <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Repuestos"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.repuestos}"/>
                                        </rich:column>
                                       <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Terminado"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.terminado}"/>
                                        </rich:column>
                                       <rich:column styleClass="#{data.colorFila}">
                                            <f:facet name="header">
                                                <h:outputText value="Horas Extra"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.registroHorasExtra}" onclick="calcularDiferenciaFechas(this);"/>
                                        </rich:column>
                                    </rich:dataTable>
                                    </div>
                                    <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.mas_action}" timeout="7200"  reRender="dataDetalle"  >
                                        <h:graphicImage url="../img/mas.png" alt="mas"/>
                                    </a4j:commandLink>
                                    <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.menos_action}" timeout="7200" reRender="dataDetalle">
                                        <h:graphicImage url="../img/menos.png" alt="menos"/>
                                    </a4j:commandLink>
                                    <br/>
                                    <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardarSeguimientoPersonalSolicitudMantenimiento}" onclick="if(cerrarOT()==false){return false;}" timeout="7200"
                                    oncomplete="if(#{ManagedSeguimientoSolicitudMantenimiento.mensaje eq '1'}){ alert('Se registraron la tareas realizadas');javascript:Richfaces.hideModalPanel('panelSeguimiento')}
                                    else{alert('#{ManagedSeguimientoSolicitudMantenimiento.mensaje}');}"
                                reRender="dataSolicitudMantenimiento" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelSeguimiento')" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             <rich:modalPanel id="panelAgregarOT"  minHeight="350"  minWidth="800"
                                     height="350" width="800"
                                     zindex="200"
                                     headerClass="cabecera"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Adjuntar Orden de Trabajo"/>
                        </f:facet>
                        <a4j:form id="form10">
                        <h:panelGroup id="contenidoAgregarOT">
                                <center>
                                    <rich:panel headerClass="cabecera">
                                    <f:facet name="header">
                                        <h:outputText value="Detalles de la Orden de Trabajo" styleClass="outputText2"/>
                                    </f:facet>

                                        <h:panelGrid columns="6" styleClass="navegadorTabla" id="cabecera" >

                                            <h:outputText  value="TECNICO" styleClass="outputText2" style="font-weight:bold"  />
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"/>
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.personal.nombrePersonal}" styleClass="outputText2"  />
                                            <h:outputText  value="Nro O.T" styleClass="outputText2"  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <a4j:commandLink onclick="Richfaces.showModalPanel('panelAsociarOT')" reRender="contenidoAsociarOT">
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.nroOrdenTrabajo}" styleClass="outputText2"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.nroOrdenTrabajo>0}"/>
                                            <h:outputText  value="seleccionar" styleClass="outputText2" 
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.nroOrdenTrabajo == 0}"/>
                                            </a4j:commandLink>
                                            <h:outputText  value="AREA EMPRESA" styleClass="outputText2"  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"/>
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"  />
                                            <h:outputText  value="INSTALACION" styleClass="outputText2"  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"/>
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"  />
                                            <h:outputText  value="MAQUINA" styleClass="outputText2"  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"/>
                                            <h:outputText  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.maquinaria.nombreMaquina}" styleClass="outputText2"  />
                                            <h:outputText styleClass="outputText2" value="Estado O.T."  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"/>
                                            <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}"  />
                                            <h:outputText  value="CERRAR O.T." styleClass="outputText2"  style="font-weight:bold"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                            <h:outputText styleClass="outputText2" value="::"  style="font-weight:bold"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                            <h:selectBooleanCheckbox value="#{ManagedSeguimientoSolicitudMantenimiento.cerrarOT}" id="cerrarOT"
                                            rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.solicitudMantenimiento.estadoSolicitudMantenimiento.codEstadoSolicitudMantenimiento !='4'}"/>
                                        </h:panelGrid>
                                </rich:panel>
                                <br/>
                                <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.seguimientoSolicitudesPersonalList}"
                                    var="data" id="dataDetalle"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="cabecera" >
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value=""/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Trabajo Realizado"/>
                                            </f:facet>
                                            <h:inputText value="#{data.descripcion}" styleClass="inputText"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Inicio"/>
                                            </f:facet>
                                            <h:inputText value="#{data.fechaInicial}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                            <h:inputText value="#{data.horaInicial}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Fecha Final"/>
                                            </f:facet>
                                            <h:inputText value="#{data.fechaFinal}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:inputText>
                                            <h:inputText value="#{data.horaFinal}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                                <f:convertDateTime pattern="HH:mm"/>
                                            </h:inputText>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Horas Hombre"/>
                                            </f:facet>
                                            <h:outputText  styleClass="outputText2" value="#{data.horasHombre}"><f:convertNumber pattern="#0.00" locale="en"/> </h:outputText>
                                            <h:inputHidden value="#{data.horasHombre}"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Horas Extra"/>
                                            </f:facet>
                                            <h:inputText value="#{data.horasExtra}" styleClass="inputText" size="5"/>
                                            
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Tipo Tarea"/>
                                            </f:facet>
                                            <h:selectOneMenu value="#{data.tiposTarea.codTipoTarea}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tiposTareasList}"/>
                                            </h:selectOneMenu>

                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Repuestos"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.repuestos}"/>
                                        </rich:column>
                                        <rich:column>
                                            <f:facet name="header">
                                                <h:outputText value="Terminado"/>
                                            </f:facet>
                                            <h:selectBooleanCheckbox value="#{data.terminado}"/>
                                        </rich:column>
                                    </rich:dataTable>
                                    <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.mas_action}"  reRender="dataDetalle" timeout="7200" >
                                        <h:graphicImage url="../img/mas.png" alt="mas"/>
                                    </a4j:commandLink>
                                    <a4j:commandLink action="#{ManagedSeguimientoSolicitudMantenimiento.menos_action}" reRender="dataDetalle" timeout="7200" >
                                        <h:graphicImage url="../img/menos.png" alt="menos"/>
                                    </a4j:commandLink>
                                    <br/>
                                    <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardarSeguimientoPersonalSolicitudMantenimiento}" onclick="if(cerrarOT()==false){return false;}"
                                    oncomplete="if(#{ManagedSeguimientoSolicitudMantenimiento.mensaje eq '1'}){ alert('Se registraron la tareas realizadas');javascript:Richfaces.hideModalPanel('panelAgregarOT')}
                                    else{alert('#{ManagedSeguimientoSolicitudMantenimiento.mensaje}');}"
                                reRender="dataSolicitudMantenimiento" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelAgregarOT')" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             <rich:modalPanel id="panelAsociarOT"  minHeight="350"  minWidth="800"
                                     height="350" width="800"
                                     zindex="200"
                                     headerClass="cabecera"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Asociar a Orden de Trabajo</center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form11">
                                <center>
                                 <h:panelGroup id="contenidoAsociarOT">
                                     <rich:panel headerClass="cabecera" style="widht:80%" rendered="#{ManagedSeguimientoSolicitudMantenimiento.registroPersonal}">
                                        <f:facet name="header">
                                            <h:outputText value="Tecnico"/>
                                        </f:facet>
                                        <center>
                                        <h:panelGrid columns="3">
                                            <h:outputText value="Tecnico" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                            <h:selectManyListbox value="#{ManagedSeguimientoSolicitudMantenimiento.codPersonal}" size="5" styleClass="inputText" id="codPersonal" >
                                                <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tecnicosSolicitudMantenimiento}"/>
                                                </h:selectManyListbox>
                                        </h:panelGrid>
                                        <h:inputHidden value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.personal.nombrePersonal}" id="nombrePersonal"/>
                                        </center>
                                    </rich:panel>
                                     
                                    <div style="overflow:auto;height:230px">
                                        <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.ordenesTrabajoDataModel}"
                                            var="data" id="dataOT"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="cabecera" >
                                                <f:facet name="header">
                                                    <rich:columnGroup>
                                                        <rich:column>
                                                            <h:outputText value="O.T"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Area Empresa"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Instalación"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Maquinaria"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Descripción"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Estado"/>
                                                        </rich:column>
                                                        <rich:column>
                                                            <h:outputText value="Tipo Solicitud"/>
                                                        </rich:column>
                                                    </rich:columnGroup>
                                                </f:facet>

                                                <rich:column>
                                                    <a4j:commandLink  action="#{ManagedSeguimientoSolicitudMantenimiento.asociarOrdenTrabajo}" title="Asociar Esta Orden de Trabajo" timeout="7200"
                                                    oncomplete="javascript:Richfaces.hideModalPanel('panelAsociarOT');" reRender="dataSolicitudMantenimiento"><%--onclick="asignarNombre()"--%>
                                                    <h:outputText value="#{data.nroOrdenTrabajo}" styleClass="outputText2"/>
                                                    </a4j:commandLink>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.obsSolicitudMantenimiento}"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}" styleClass="outputText2"/>
                                                </rich:column>
                                                <rich:column>
                                                    <h:outputText value="#{data.tiposSolicitudMantenimiento.nombreTipoSolicitud}" styleClass="outputText2"/>
                                                </rich:column>

                                          </rich:dataTable>
                                  </div>
                                  </h:panelGroup>
                                  <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelAsociarOT')" />
                                </center>
                        </a4j:form>
            </rich:modalPanel>
             <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
         <h:panelGroup   id="panelsuper"  styleClass="panelSuper" style="visibility:hidden"  >
         </h:panelGroup>
        </body>
    </html>
    
</f:view>