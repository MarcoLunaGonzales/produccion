<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script type="text/javascript">
                function retornarNavegador(codVersionCp)
                {
                    window.location.href=(codVersionCp>0?'../navegadorComponentesProdVersion.jsf':'../navegadorNuevosComponentesProd.jsf')+"?data="+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarAgregarComponentesProdVersionFiltroProduccion}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Filtro de Producción" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Forma farmaceútica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion} " styleClass="outputText2"/>
                               
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.filtrosProduccionAgregarList}"
                                            var="data" id="dataAgregarFiltroProduccion" 
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText escape="false" value="Cantidad del<br>Filtro"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de Medida<br>(filtro)" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Codigo del<br>filtro" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Presión de Aprobación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad de Medida<br>Presión" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Medio de Filtración" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                               <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.cantidadFiltro}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.codigoFiltroProduccion}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.presionAprobación}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.unidadesMedidaPresion.nombreUnidadMedida}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.mediosFiltracion.nombreMedioFiltracion}"/>
                                </rich:column>
                        </rich:dataTable>
                        <div style='margin-top:1em'>
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarAgregarComponentesProdVersionFiltroProduccion_action}"
                                               onclick="if(!editarItems('form1:dataAgregarFiltroProduccion')){return false;}"
                                               oncomplete="if(#{ManagedComponentesProdVersion.mensaje eq '1'}){alert('La información se guardo de forma correcta');window.location.href='navegadorFiltrosProduccionProducto.jsf?save='+(new Date()).getTime().toString();}
                                               else{alert('#{ManagedComponentesProdVersion.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorFiltrosProduccionProducto.jsf?dontsave='+(new Date()).getTime().toString()"/>
                         </div>   
                         
                </div>

               
              
            </a4j:form>

             
             <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>

</f:view>

