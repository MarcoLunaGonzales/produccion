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
          function validaFecha(input){var a = new Date();
              //var regexp = new RegExp('/^\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}$/');
              //if(!input.value.match(regexp)){
                  //alert('no coinciden')

              //}
              //alert(input.value);
              //re = ^((((([0-1]?\d)|(2[0-8]))\/((0?\d)|(1[0-2])))|(29\/((0?[1,3-9])|(1[0-2])))|(30\/((0?[1,3-9])|(1[0-2])))|(31\/((0?[13578])|(1[0-2]))))\/((19\d{2})|([2-9]\d{3}))|(29\/0?2\/(((([2468][048])|([3579][26]))00)|(((19)|([2-9]\d));
              //valor = strtotime(input.value);
              //if(valor ==false){
              //    alert("no coincide");

              //}
              
          }

       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedSolicitudMantenimientoDetalleTareas.cargarContenidoSolicitudMantenimientoDetalleTareas}"/>
                    
                    <br><br>

                        <rich:panel headerClass="headerClassACliente" style="width:80%">
                            <f:facet name="header">
                                    <h:outputText value="Listado de Tareas De Solicitud Mantenimiento"/>
                            </f:facet>
                            <h:panelGrid columns="4">
                                <h:outputText value="Nro. O.T.:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.nroOrdenTrabajo}" styleClass="outputText2"/>
                                <h:outputText value="Area Empresa:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                                <h:outputText value="Maquinaria:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.maquinaria.nombreMaquina}" styleClass="outputText2"/>
                                <h:outputText value="Instalación:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.areasInstalaciones.nombreAreaInstalacion}" styleClass="outputText2"/>
                                <h:outputText value="Modulo Instalacacion:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.modulosInstalaciones.nombreModuloInstalacion}" styleClass="outputText2"/>

                                <h:outputText value="Solicitante:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.personal_usuario.nombrePersonal}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Solicitud Mantenimiento:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.tiposSolicitudMantenimiento.nombreTipoSolMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Fecha Solicitud:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.fechaSolicitudMantenimiento}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Fecha Aprobacion:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.fechaAprobacion}" styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                                <h:outputText value="Estado Solicitud:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.estadoSolicitudMantenimiento.nombreEstadoSolicitudMantenimiento}" styleClass="outputText2"/>
                                <h:outputText value="Descripción Estado:" styleClass="outputText2"/>
                                <h:outputText value="#{ManagedSolicitudMantenimiento.solicitudMantenimientoItem.descripcionEstado}" styleClass="outputText2"/>

                            </h:panelGrid>
                        </rich:panel>
                        <h:outputText styleClass="outputTextTitulo"  value="Listado de Personal Asignado" />
                    <rich:dataTable value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareasList}" var="data"
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
                                <h:outputText value="Personal "  />
                            </f:facet>
                            <h:outputText value="#{data.personal.nombrePersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apPaternoPersonal}" />
                            <h:outputText value=" " />
                            <h:outputText value="#{data.personal.apMaternoPersonal}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Proveedor"  />
                            </f:facet>
                            <h:outputText value="#{data.proveedores.nombreProveedor}" />
                        </h:column>

                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha/Hora Inicio"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicial}" >
                                <f:convertDateTime pattern="dd/MM/yyyy hh:mm" />
                            </h:outputText>
                        </h:column--%>
                        <%--h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcion}" />
                        </h:column--%>
                        
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>
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
                    
                    <a4j:commandButton styleClass="btn" value="Aceptar" oncomplete="if(#{ManagedSolicitudMantenimientoDetalleTareas.mensaje!=''}){alert('#{ManagedSolicitudMantenimientoDetalleTareas.mensaje}');}location='navegador_aprobar_solicitud_mantenimiento.jsf';" action="#{ManagedSolicitudMantenimientoDetalleTareas.generarSolicitudMantenimiento_action}"  />

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />

            </a4j:form>



             <rich:modalPanel id="panelAgregarSolicitudMantenimientoDetalleTareas" minHeight="250"  minWidth="800"
                                     height="250" width="800"
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


                                    <%--h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.descripcion}"/--%>

                                    <h:outputText  value="" styleClass="outputText2"  />
                                    <h:outputText value="" styleClass="outputText2"   />
                                    <h:selectOneRadio value="#{ManagedSolicitudMantenimientoDetalleTareas.enteAsignado}" id="asignado" styleClass="outputText2" onclick="javascript:seleccionarAsignado2();" >
                                        <f:selectItem id="item1" itemLabel="Personal Asignado" itemValue="interno"/>
                                        <f:selectItem id="item2" itemLabel="Proovedor Asignado" itemValue="externo" />
                                    </h:selectOneRadio>

                                    <h:outputText  value="Personal Asignado" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:panelGrid>

                                        <h:selectManyListbox id="selectPersonal" styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.codPersonalAsignar}">
                                            <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.personalList}"/>
                                        </h:selectManyListbox>

                                        <h:selectOneMenu id="selectProovedor" styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.proveedores.codProveedor}">
                                            <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.proovedorList}"/>
                                        </h:selectOneMenu>
                                    </h:panelGrid>

                                    <%--h:outputText  value="Fecha Inicial" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputText value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.fechaInicial}" styleClass="inputText" onblur="validaFecha(this)" >
                                        <f:convertDateTime pattern="dd/MM/yyyy hh:mm" />
                                    </h:inputText--%>

                                    
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

            <rich:modalPanel id="panelEditarSolicitudMantenimientoDetalleTareas"  minHeight="250"  minWidth="800"
                                     height="250" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarSolicitudMantenimientoDetalleTareas">

                                <h:panelGrid columns="3" styleClass="navegadorTabla" >

                                    <h:outputText  value="Tipo de Trabajo" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />

                                    <h:selectOneMenu  styleClass="inputText" value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.tiposTarea.codTipoTarea}">
                                        <f:selectItems value="#{ManagedSolicitudMantenimientoDetalleTareas.tiposTareasList}"/>
                                    </h:selectOneMenu>


                                    <h:outputText value="Descripción" styleClass="outputText2"   />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputTextarea styleClass="inputText" rows="2" cols="38"  value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.descripcion}"/>

                                    <h:outputText  value="" styleClass="outputText2"  />
                                    <h:outputText value="" styleClass="outputText2"   />
                                    <h:selectOneRadio value="#{ManagedSolicitudMantenimientoDetalleTareas.enteAsignado}" id="asignado" styleClass="outputText2" onclick="javascript:seleccionarAsignado3();" >
                                        <f:selectItem id="item1" itemLabel="Personal Asignado" itemValue="interno"/>
                                        <f:selectItem id="item2" itemLabel="Proovedor Asignado" itemValue="externo" />
                                    </h:selectOneRadio>

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

                                    <h:outputText  value="Fecha Inicial" styleClass="outputText2"  />
                                    <h:outputText styleClass="outputText2" value="::"  />
                                    <h:inputText value="#{ManagedSolicitudMantenimientoDetalleTareas.solicitudMantenimientoDetalleTareas.fechaInicial}" styleClass="inputText" onblur="validaFecha(this)" >
                                        <f:convertDateTime pattern="dd/MM/yyyy hh:mm" />
                                    </h:inputText>


                                 
                                    
                                </h:panelGrid>
                                <div align="center">

                                <a4j:commandButton value="Guardar" styleClass="btn"  action="#{ManagedSolicitudMantenimientoDetalleTareas.guardarEdicionSolicitudMantenimientoDetalleTareas_action}"
                                oncomplete="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')"
                                reRender="dataSolicitudMantenimientoDetalleTareas" />
                                <a4j:commandButton value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarSolicitudMantenimientoDetalleTareas')" />
                                </div>
                        </h:panelGroup>
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

