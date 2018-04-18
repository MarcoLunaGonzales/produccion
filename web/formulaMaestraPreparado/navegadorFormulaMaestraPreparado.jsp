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
        function validarIngresoFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form2:codMaquina").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
        function validarEdicionFormulaMaestraDetalleFPActividad(){
            if(document.getElementById("form3:codMaquina").value==0){
                    alert('seleccione un Material');
                    return false;
                }
            return true;
        }
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraPreparado.cargarContenidoFormulaMaestraPreparado}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Maquinarias de Actividad" />
                    <br><br>

                    <rich:dataTable value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparadoList}" var="data"
                                    id="dataFormulaMaestraPreparado"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparadoDataTable}">


                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Precaucion"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcionPrecaucion}" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Maquinaria"  />
                            </f:facet>
                            <h:outputText value="#{data.maquinaria.nombreMaquina}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Agitador"  />
                            </f:facet>
                            <h:outputText value="#{data.partesMaquinaria.nombreParteMaquina}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Temperatura Maxima"  />
                            </f:facet>
                            <h:outputText value="#{data.temperaturaMaxima}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Humedad Relativa Maxima"  />
                            </f:facet>
                            <h:outputText value="#{data.humedadRelativaMaxima}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fases Preparado"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedFormulaMaestraPreparado.verFormulaMaestraDetalleFP_action}" >
                                <h:graphicImage value="../img/organigrama3.jpg" />
                            </a4j:commandLink>
                            <h:outputText value=""  />
                        </h:column>
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>                    
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarFormulaMaestraPreparado')"
                    action="#{ManagedFormulaMaestraPreparado.agregarFormulaMaestraPreparado_action}"
                    reRender="contenidoAgregarFormulaMaestraPreparado" />
                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataFormulaMaestraPreparado')==false){return false;}else{Richfaces.showModalPanel('panelEditarFormulaMaestraPreparado')}"
                    action="#{ManagedFormulaMaestraPreparado.editarFormulaMaestraPreparado_action}"
                    reRender="contenidoEditarFormulaMaestraPreparado" />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataFormulaMaestraPreparado')==false){return false;}"
                    action="#{ManagedFormulaMaestraPreparado.eliminarFormulaMaestraPreparado_action}"
                    reRender="dataFormulaMaestraPreparado"/>

                    <a4j:commandButton styleClass="btn" value="Cancelar" onclick="location='../formula_maestra/navegador_formula_maestra.jsf'" />
                    

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />                
            </a4j:form>



             <rich:modalPanel id="panelAgregarFormulaMaestraPreparado" minHeight="300"  minWidth="400"
                                     height="300" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Maquinaria Actividad Fase"/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoAgregarFormulaMaestraPreparado">
                            <h:panelGrid columns="3">

                                <h:outputText value="Precaucion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.descripcionPrecaucion}" styleClass="inputText" cols="50" rows="4" />

                                <h:outputText value="Observacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.observacion}" styleClass="inputText" cols="50" rows="4" />

                                <h:outputText value="Maquinaria" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.maquinaria.codMaquina}" id="codMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraPreparado.maquinariasList}" />
                                    <a4j:support action="#{ManagedFormulaMaestraPreparado.maquinaria_change}" event="onchange" reRender="codParteMaquina" />
                                </h:selectOneMenu>

                                <h:outputText value="Agitador" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.partesMaquinaria.codParteMaquina}" id="codParteMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraPreparado.partesMaquinariaList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Temperatura Maxima" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.temperaturaMaxima}" styleClass="inputText"/>
                                
                                <h:outputText value="Humedad Relativa Maxima" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.humedadRelativaMaxima}" styleClass="inputText"/>

                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" 
                                onclick="if(validarIngresoFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraPreparado');}"
                                action="#{ManagedFormulaMaestraPreparado.registrarFormulaMaestraPreparado_action}" reRender="dataFormulaMaestraPreparado"
                                                    />                                
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraPreparado')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarFormulaMaestraPreparado" minHeight="400"  minWidth="400"
                                     height="400" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form id="form3">
                        <h:panelGroup id="contenidoEditarFormulaMaestraPreparado">
                           <h:panelGrid columns="3">

                                <h:outputText value="Precaucion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.descripcionPrecaucion}" styleClass="inputText" cols="50" rows="4" />

                                <h:outputText value="Observacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.observacion}" styleClass="inputText" cols="50" rows="4" />

                                <h:outputText value="Maquinaria" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.maquinaria.codMaquina}" id="codMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraPreparado.maquinariasList}" />
                                    <a4j:support action="#{ManagedFormulaMaestraPreparado.maquinaria_change}" event="onchange" reRender="codParteMaquina" />
                                </h:selectOneMenu>

                                <h:outputText value="Agitador" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu styleClass="inputText" value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.partesMaquinaria.codParteMaquina}" id="codParteMaquina">
                                    <f:selectItems value="#{ManagedFormulaMaestraPreparado.partesMaquinariaList}" />
                                    
                                </h:selectOneMenu>


                                <h:outputText value="Temperatura Maxima" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.temperaturaMaxima}" styleClass="inputText"/>

                                <h:outputText value="Humedad Relativa Maxima" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraPreparado.formulaMaestraPreparado.humedadRelativaMaxima}" styleClass="inputText"/>

                                
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" 
                                onclick="if(validarEdicionFormulaMaestraDetalleFPActividad()==false){return false;}else{javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraPreparado');}"
                                
                                action="#{ManagedFormulaMaestraPreparado.guardarFormulaMaestraPreparado_action}" reRender="dataFormulaMaestraPreparado"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraPreparado')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

