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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
            <script>
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


                        if(confirm('Desea Eliminar el Registro')){
                            if(confirm('Esta seguro de Eliminar el Registro')){
                                
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }
                    }
                }
            </script>
        </head>
        <body>
           
            <h:form id="form1"  >
                <div align="center">                    
                        <br><br>                
                    <h:outputText value="#{ManagedComponentesProducto.cargarPresentacionesSecundariasComponentesProdVersion}"   />
                    <h3>Presentaciones Secundarias</h3>
                    <h:outputText value="#{ManagedComponentesProducto.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                    <br><br>
                      <rich:dataTable value="#{ManagedComponentesProducto.componentesPresProdList}" var="data" id="dataComponentesPresProd"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />                            
                        </rich:column >                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Envase Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.presentacionesProducto.nombreProductoPresentacion}"  />
                        </rich:column >                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantiad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantCompProd}"  />
                        </rich:column >
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column >
                    </rich:dataTable>
                    
                    <br>
                        
                    <a4j:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedComponentesProducto.agregarComponentesPresProd_action}" oncomplete="Richfaces.showModalPanel('panelAgregarPresentacionSecundaria')" 
                                       reRender="contenidoAgregarPresentacionSecundaria" />
                    <a4j:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.eliminarComponentesPresProdVersion_action}"
                                       reRender="dataComponentesPresProd" /> <%-- onclick="return eliminar('form1:dataComponentesPresProd');" --%>
                    <a4j:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.editarComponentesPresProd_action}"
                                       reRender="contenidoEditarPresentacionSecundaria" oncomplete="Richfaces.showModalPanel('panelEditarPresentacionSecundaria')" />
                    <a4j:commandButton value="Cancelar"  styleClass="commandButton" onclick="location='#{ManagedComponentesProducto.direccion}'" />
                </div>
            </h:form>

            <rich:modalPanel id="panelAgregarPresentacionSecundaria" minHeight="200"  minWidth="650"
                                     height="200" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Fases Formula Maestra"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoAgregarPresentacionSecundaria">
                            <h:panelGrid columns="3">
                                <h:outputText value="Presentacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProd.presentacionesProducto.codPresentacion}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.presentacionesSecundariasList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Cantidad de Producto Semiterminado" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedComponentesProducto.componentesPresProd.cantCompProd}" styleClass="inputText" />

                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProd.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.tiposProgramaProduccionList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Estado" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProd.estadoReferencial.codEstadoRegistro}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.estadoRegistroList}" />
                                </h:selectOneMenu>
                                <%--h:inputText value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.descripcionFase}" styleClass="inputText" size="" /--%>
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarPresentacionSecundaria');"
                                action="#{ManagedComponentesProducto.guardarComponentesPresProdVersion_action}" reRender="dataComponentesPresProd"
                                />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarPresentacionSecundaria')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            

            <rich:modalPanel id="panelEditarPresentacionSecundaria" minHeight="200"  minWidth="650"
                                     height="200" width="650"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Presentaciones"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoEditarPresentacionSecundaria">
                                <h:panelGrid columns="3">
                                <h:outputText value="Presentacion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProdEditar.presentacionesProducto.codPresentacion}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.presentacionesSecundariasList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Cantidad de Producto Semiterminado" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedComponentesProducto.componentesPresProdEditar.cantCompProd}" styleClass="inputText" />

                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProdEditar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.tiposProgramaProduccionList}" />
                                </h:selectOneMenu>

                                <h:outputText value="Estado" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedComponentesProducto.componentesPresProdEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedComponentesProducto.estadoRegistroList}" />
                                </h:selectOneMenu>
                                </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="javascript:Richfaces.hideModalPanel('panelEditarPresentacionSecundaria');"
                                action="#{ManagedComponentesProducto.guardarEditarComponentesPresProdVersion_action}" reRender="dataComponentesPresProd"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarPresentacionSecundaria')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

