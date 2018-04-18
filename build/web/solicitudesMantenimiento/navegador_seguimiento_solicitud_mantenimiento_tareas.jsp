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
            function calcularDiferenciaFechas()
            {
                var fecha1=document.getElementById("form10:fechaInicioEditar").value+' '+document.getElementById("form10:horaInicioEditar") .value;
                var fecha2=document.getElementById("form10:fechaFinalEditar").value+' '+document.getElementById("form10:horaFinalEditar") .value;
                document.getElementById("form10:cantidadHoras").value=getNumeroDehoras(fecha1,fecha2);
                document.getElementById("form10:spanHoras").innerHTML=document.getElementById("form10:cantidadHoras").value+' horas';
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

       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.cargarSolicitudMantenimientoDetalleTareas}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Tareas de Solicitud de Mantenimiento" />
                    <br><br>
                        <%--h:outputText styleClass="outputTextTitulo"  value="Listado de Tareas de Solicitud de Mantenimiento" /--%>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                    <h:outputText value="Listado de Tareas De Solicitud Mantenimiento"/>
                            </f:facet>
                            <h:panelGrid columns="4">
                                <h:outputText value="Nro. O.T.:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.nroOrdenTrabajo}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Maquinaria:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Instalación:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                                <h:outputText value="Modulo Instalacacion:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.modulosInstalaciones.nombreModuloInstalacion}" styleClass="outputText2"/>

                                <h:outputText value="Solicitante:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Solicitud Mantenimiento:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.tiposSolicitudMantenimiento.nombreTipoSolMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Solicitud:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.fechaSolicitudMantenimiento}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Fecha Aprobacion:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.fechaAprobacion}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Estado Solicitud:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Descripción Estado:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoItem.descripcionEstado}" styleClass="outputText2"/>

                            </h:panelGrid>
                        </rich:panel>

                    <rich:dataTable value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareasList}" var="data"
                                    id="dataSolicitudMantenimientoDetalleTareas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareasDataTable}" >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Tarea"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposTarea.nombreTipoTarea}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Personal Asignado"  />
                            </f:facet>
                            <h:outputText value="#{data.personal.nombrePersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apPaternoPersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apMaternoPersonal}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Proveedor Asignado"  />
                            </f:facet>
                            <h:outputText value="#{data.proveedores.nombreProveedor}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcion}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Inicial"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicial}" >
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                            </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Final"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}" >
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                            </h:outputText>
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Horas Hombre"  />
                            </f:facet>
                            <h:outputText value="#{data.horasHombre}" />                            
                        </h:column>
                        
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>

                     <a4j:commandButton value="Agregar" styleClass="btn" action="#{ManagedSeguimientoSolicitudMantenimiento.agregarHorasSolicitudMantenimiento_action}"
                     oncomplete="Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoTareas')" reRender="contenidoAgregarSolicitudMantenimientoTareas"/>

                     <a4j:commandButton value="Editar" styleClass="btn" onclick="if(editarItem('form1:dataSolicitudMantenimientoDetalleTareas')==false){return  false;}"
                     action="#{ManagedSeguimientoSolicitudMantenimiento.editarHorasSolicitudMantenimiento_action}"
                     oncomplete="Richfaces.showModalPanel('panelEditarSolicitudMantenimientoTareas')" reRender="contenidoEditarSolicitudMantenimientoTareas"/>

                     

                     <a4j:commandButton value="Finalizar Trabajo"  styleClass="btn"
                     onclick="javascript:if(validarSeleccion('form1:dataSolicitudMantenimientoDetalleTareas')==false){return false;}else{Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')}"
                     action="#{ManagedSeguimientoSolicitudMantenimiento.editarSolicitudMantenimientoDetalleTareas_action}"
                     reRender="contenidoEditarSolicitudMantenimientoDetalleTareas"
                     oncomplete="seleccionarAsignado3()"
                     />

                     <%--
                     <a4j:commandButton value="Guardar" styleClass="btn"
                     action="#{ManagedSeguimientoSolicitudMantenimiento.guardarSeguimientoTareasSolicitudMantenimiento_action}"
                     oncomplete="location='navegador_seguimiento_solicitud_mantenimiento.jsf'"  />

                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')"
                    action="#{ManagedSolicitudMantenimientoDetalleTareas.agregarSolicitudMantenimientoDetalleTareas_action}"
                    reRender="contenidoAgregarSolicitudMantenimientoDetalleTareas"
                    oncomplete="seleccionarAsignado2()"  />

                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')"
                    action="#{ManagedSolicitudMantenimientoDetalleTareas.agregarSolicitudMantenimientoDetalleTareas_action}"
                    reRender="contenidoAgregarSolicitudMantenimientoDetalleTareas"
                    oncomplete="seleccionarAsignado2()"  />

                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataSolicitudMantenimientoDetalleTareas')==false){return false;}else{Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')}"
                    action="#{ManagedSolicitudMantenimientoDetalleTareas.editarSolicitudMantenimientoDetalleTareas_action}"
                    reRender="contenidoEditarSolicitudMantenimientoDetalleTareas"
                    oncomplete="seleccionarAsignado3()"

                    />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataSolicitudMantenimientoDetalleTareas')==false){return false;}"
                    action="#{ManagedSolicitudMantenimientoDetalleTareas.eliminarSolicitudMantenimientoDetalleTareas_action}"
                    reRender="dataSolicitudMantenimientoDetalleTareas"/>
                    --%>
                
                    <a4j:commandButton styleClass="btn" value="Aceptar" onclick="location='navegador_seguimiento_solicitud_mantenimiento.jsf'" />

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />

            </a4j:form>



             <rich:modalPanel id="panelAgregarSolicitudMantenimientoDetalleTareas" minHeight="150"  minWidth="400"
                                     height="300" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Tarea"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoAgregarSolicitudMantenimientoDetalleTareas">                             
                                
                                <h:panelGrid columns="3" styleClass="navegadorTabla" >
                                   
                                    <h:outputText  value="Tipo de Trabajo" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.tiposTarea.codTipoTarea}">
                                        <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.tiposTareasList}"/>
                                    </h:selectOneMenu>


                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.descripcion}"/>


                                    <h:outputText  value="Personal Asignado" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGrid>
                                        <h:selectOneMenu id="selectPersonal" styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.personal.codPersonal}">
                                            <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.personalList}"/>
                                        </h:selectOneMenu>
                                        <h:selectOneMenu id="selectProovedor" styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.proveedores.codProveedor}">
                                            <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.proovedorList}"/>
                                        </h:selectOneMenu>
                                    </h:panelGrid>


                                    <h:outputText  value="" styleClass="outputText2"  />
                                    <h:outputText value="" styleClass="outputText2"   />
                                    <h:selectOneRadio value="#{ManagedSolicitudMantenimientoDetalleTareas.enteAsignado}" id="asignado" styleClass="outputText2" onclick="javascript:seleccionarAsignado2();" >
                                        <f:selectItem id="item1" itemLabel="Personal Asignado" itemValue="interno"/>
                                        <f:selectItem id="item2" itemLabel="Proovedor Asignado" itemValue="externo" />
                                    </h:selectOneRadio>
                                    


                                    <h:outputText  value="Fecha Inicio" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <rich:calendar  datePattern="dd/MM/yyyy" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.fechaInicial}" id="fechaInicio" enableManualInput="true"   />

                                    <h:outputText  value="Fecha Final" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <rich:calendar   datePattern="dd/MM/yyyy" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.fechaFinal}" id="fechaFinal" enableManualInput="true" />                                   
                                   
                                </h:panelGrid>
                                <div align="center">
                                
                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleTareas.registrarSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoDetalleTareas')" />
                                </div>
                            
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarSolicitudMantenimientoDetalleTareas"  minHeight="350"  minWidth="800"
                                     height="350" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Finalizar Tarea"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarSolicitudMantenimientoDetalleTareas">

                                <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                    <h:outputText  value="Tipo de Trabajo" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.tiposTarea.codTipoTarea}">
                                        <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tiposTareasList}"/>
                                    </h:selectOneMenu>


                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="4" cols="60"  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.descripcion}"/>


                                    <h:outputText  value="Personal Asignado" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGrid>
                                        <h:selectOneMenu id="selectPersonal" styleClass="inputText" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.personal.codPersonal}">
                                            <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.personalList}"/>
                                        </h:selectOneMenu>
                                        
                                        <h:selectOneMenu id="selectProovedor" styleClass="inputText" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.proveedores.codProveedor}" style="width:auto">
                                            <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.proveedorList}"/>
                                        </h:selectOneMenu>
                                        
                                    </h:panelGrid>


                                    <h:outputText  value="" styleClass="outputText2"  />
                                    <h:outputText value="" styleClass="outputText2"   />
                                    <h:selectOneRadio value="#{ManagedSeguimientoSolicitudMantenimiento.enteAsignado}" id="asignado" styleClass="outputText2" onclick="javascript:seleccionarAsignado3();" >
                                        <f:selectItem id="item1" itemLabel="Personal Asignado" itemValue="interno"/>
                                        <f:selectItem id="item2" itemLabel="Proovedor Asignado" itemValue="externo" />
                                    </h:selectOneRadio>


                                    <h:outputText value="Duracion de Tarea" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputText styleClass="inputText"  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.horasHombre}" onkeypress="valNum();" />

                                    
                                    

                                    <h:outputText  value="Fecha de Finalizacion" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.fechaFinal}" styleClass="inputText" >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                    </h:inputText>

                                    <h:outputText  value="Generar Solicitud Preventiva" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:selectBooleanCheckbox value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.conSolicitudMantenimientoPreventiva}"  >
                                        <a4j:support action="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo_action}" 
                                        event="onclick"
                                        reRender="contenidoEditarSolicitudMantenimientoDetalleTareas"
                                        oncomplete="if(#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.conSolicitudMantenimientoPreventiva})
                                        {Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleTareas',{height:500})}else{Richfaces.showModalPanel('panelEditarSolicitudMantenimientoDetalleTareas',{height:350})}" />
                                    </h:selectBooleanCheckbox>
                                </h:panelGrid>
                                
                                
                                <h:panelGrid columns="3" id="contenidoSolicitudPreventiva" style="border-style:solid;border-color:black;border-width:thin" rendered="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoDetalleTareas.conSolicitudMantenimientoPreventiva}" width="100%">
                                            

                                            <h:outputText styleClass="outputText2" value="Maquinaria"  />
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.maquinaria.nombreMaquina}" styleClass="inputText" readonly="true" />
                                            
                                            <h:outputText  styleClass="outputText2" value="Instalacion"  />
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <h:panelGroup>
                                                <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.areasInstalaciones.nombreAreaInstalacion}(#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.modulosInstalaciones.nombreModuloInstalacion})" styleClass="inputText" size="50" readonly="true" />&nbsp;
                                                <%--(<h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.modulosInstalaciones.nombreModuloInstalacion}" styleClass="inputText" />)--%>
                                            </h:panelGroup>

                                            <h:outputText styleClass="outputText2" value="Observaciones"  />
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <h:inputTextarea value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.obsSolicitudMantenimiento}" styleClass="inputText" rows="4" cols="50" />
                                            
                                            <h:outputText  styleClass="outputText2" value="Afecta a Produccion"  />
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <h:selectOneMenu  styleClass="inputText" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.afectaraProduccion}"  >
                                                <f:selectItem itemLabel="SI" itemValue="1" />
                                                <f:selectItem itemLabel="NO" itemValue="0" />
                                            </h:selectOneMenu>

                                            <h:outputText  styleClass="outputText2" value="Prioridad"  />
                                            <h:outputText styleClass="outputText2" value="::"  />
                                            <h:selectOneMenu  styleClass="inputText" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudMantenimientoPreventivo.tiposNivelSolicitudMantenimiento.codTipoNivelSolicitudMantenimiento}"  >
                                                <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.tiposNivelSolicitudMantenimientoList}" />
                                            </h:selectOneMenu>


                                            
                                 </h:panelGrid>
                                <br/>
                                <div align="center" >

                                <a4j:commandButton value="Finalizar Tarea" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardarEdicionSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelEditarSolicitudMantenimientoTareas"  minHeight="300"  minWidth="600"
                                     height="300" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Solicitud Tareas"/>
                        </f:facet>
                        <a4j:form id="form10">
                        <h:panelGroup id="contenidoEditarSolicitudMantenimientoTareas">
                                <center>
                                <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                    <h:outputText  value="Tipo de Trabajo" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.tiposTarea.nombreTipoTarea}"  />
                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="4" cols="60"  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.descripcion}"/>


                                    <h:outputText  value="Personal Asignado" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.personal.nombrePersonal}
                                    #{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.personal.apPaternoPersonal} #{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.personal.apMaternoPersonal}"  />
                                    <h:outputText  value="Fecha Inicial" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGroup>
                                        <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.fechaInicial}" id="fechaInicioEditar" styleClass="inputText"
                                        onkeyup="calcularDiferenciaFechas()" size="10" onblur="validarFecha(this)">
                                        <f:convertDateTime pattern="dd/MM/yyyy" />
                                    </h:inputText>
                                    <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.horaInicial}" id="horaInicioEditar" styleClass="inputText"  onkeyup="calcularDiferenciaFechas()"
                                    size="5" onblur="validarHora(this)">
                                        <f:convertDateTime pattern="HH:mm" />
                                    </h:inputText>
                                    </h:panelGroup>
                                    <h:outputText  value="Fecha Final" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGroup>
                                        <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.fechaFinal}" id="fechaFinalEditar" styleClass="inputText"
                                        onkeyup="calcularDiferenciaFechas()" size="10" onblur="validarFecha(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy" />
                                            </h:inputText>
                                            <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.horaFinal}" id="horaFinalEditar" styleClass="inputText" onkeyup="calcularDiferenciaFechas()"
                                            size="5" onblur="validarHora(this)">
                                                <f:convertDateTime pattern="HH:mm" />
                                            </h:inputText>
                                    </h:panelGroup>
                                    <h:outputText value="Duracion de Tarea" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.horasHombre} horas"  id="spanHoras" />
                                    <h:inputHidden  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasEditar.horasHombre}" id="cantidadHoras" />



                                </h:panelGrid>


                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardarEdicionHorasSolicitudMantenimiento_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoTareas')" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelAgregarSolicitudMantenimientoTareas"  minHeight="300"  minWidth="600"
                                     height="300" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Solicitud Tareas"/>
                        </f:facet>
                        <a4j:form id="form9">
                        <h:panelGroup id="contenidoAgregarSolicitudMantenimientoTareas">
                                <center>
                                <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                    <h:outputText  value="Personal - tarea" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:selectOneMenu value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.personal.codPersonal}" styleClass="inputText">
                                        <f:selectItems value="#{ManagedSeguimientoSolicitudMantenimiento.personalTareasList}"/>
                                    </h:selectOneMenu>
                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="4" cols="60"  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.descripcion}"/>

                                    <h:outputText  value="Fecha Inicial" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGroup>
                                        <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.fechaInicial}" id="fechaInicioEditar1" styleClass="inputText"
                                        onkeyup="calcularDiferenciaFechas1()" size="10"  onblur="validarFecha(this)">
                                        <f:convertDateTime pattern="dd/MM/yyyy" />
                                    </h:inputText>
                                    <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.horaInicial}" id="horaInicioEditar1" styleClass="inputText"
                                    onkeyup="calcularDiferenciaFechas1()" size="5" onblur="validarHora(this)">
                                        <f:convertDateTime pattern="HH:mm" />
                                    </h:inputText>
                                    </h:panelGroup>
                                    <h:outputText  value="Fecha Final" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGroup>
                                        <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.fechaFinal}" id="fechaFinalEditar1" styleClass="inputText"
                                        onkeyup="calcularDiferenciaFechas1()" size="10" onblur="validarFecha(this)">
                                                <f:convertDateTime pattern="dd/MM/yyyy" />
                                            </h:inputText>
                                            <h:inputText value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.horaFinal}" id="horaFinalEditar1" styleClass="inputText"
                                            onkeyup="calcularDiferenciaFechas1()"  size="5" onblur="validarHora(this)">
                                                <f:convertDateTime pattern="HH:mm" />
                                            </h:inputText>
                                    </h:panelGroup>
                                    <h:outputText value="Duracion de Tarea" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:outputText styleClass="outputText2" value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.horasHombre} horas"  id="spanHoras1" />
                                    <h:inputHidden  value="#{ManagedSeguimientoSolicitudMantenimiento.solicitudTareasAgregar.horasHombre}" id="cantidadHoras1" />



                                </h:panelGrid>


                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSeguimientoSolicitudMantenimiento.guardarPersonalTareasSeguimiento_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelAgregarSolicitudMantenimientoTareas')" />
                                </center>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>

</f:view>

