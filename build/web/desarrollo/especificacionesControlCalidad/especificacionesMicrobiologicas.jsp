<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js"></script>
            <script>
                   A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            }
            else
            {
            return false;
            }
            }
            
            </script>
            <style>
                .activo
                {
                    background-color:#90EE90;
                }
            </style>
        </head>
        <body >    
            <center>                    
                <h:form id="form1"  >
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarEspecificacionesMicrobiologicasProducto}"/>

                     <rich:panel headerClass="headerClassACliente" style="width:50%">
                        <f:facet name="header">
                            <h:outputText value="Datos Generales"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nro Versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nroVersion}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Nombre Comercial" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.componentesProdVersionSeleccionado.producto.nombreProducto}" styleClass="outputText2"/>
                        </h:panelGrid>

                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.especificacionesMicrobiologiaProductoList}" 
                                    var="data" id="dataEspecificacionesFisicas"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                         <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value="Habilitado"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Analisis Microbiologico"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Especificación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Referencia"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:columnGroup style="background-color:#{data.checked?'#90EE90':''}">
                             <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}"  onclick="seleccionarRegistro(this);" />
                            </rich:column >
                            <rich:column>
                                <h:outputText value="#{data.especificacionMicrobiologiaCc.nombreEspecificacion}"  />
                            </rich:column >
                            <rich:column>
                                <h:inputText value="#{data.descripcion}" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}"  styleClass="inputText"/>
                                <h:panelGrid columns="3" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                    <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNum(event)" styleClass="inputText" />
                                <h:outputText value="-" />
                                <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNum(event)" styleClass="inputText"/>
                                </h:panelGrid>
                                <h:panelGrid columns="2" rendered="#{(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')&&(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')}">

                                <h:outputText value="#{data.especificacionMicrobiologiaCc.coeficiente} #{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.simbolo}" styleClass="outputText2"/>
                                <h:inputText value="#{data.valorExacto}" size="5" onkeypress="valNum(event)" styleClass="inputText"/>
                                </h:panelGrid>
                            </rich:column >
                             <rich:column>
                                 <h:selectOneMenu value="#{data.especificacionMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                     <f:selectItems value="#{ManagedProductosDesarrolloVersion.tiposReferenciaCcSelect}"/>
                                 </h:selectOneMenu>
                            </rich:column >
                        </rich:columnGroup>
 
                   </rich:dataTable>

                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton value="Guardar" styleClass="btn" 
                                           action="#{ManagedProductosDesarrolloVersion.guardarEspecificacionesMicrobiologicasProductoAction()}"
                                           oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se registraron las especificaciones microbiologicas');redireccionar('../navegadorProductosDesarrolloEnsayos.jsf')}
                                            else {alert('#{ManagedProductosDesarrolloVersion.mensaje}');}"/>
                        <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="redireccionar('../navegadorProductosDesarrolloEnsayos.jsf')"/>
                    </div>        
                </h:form>
                <a4j:include viewId="/panelProgreso.jsp" />
            </center>    
        </body>
    </html>
    
</f:view>

