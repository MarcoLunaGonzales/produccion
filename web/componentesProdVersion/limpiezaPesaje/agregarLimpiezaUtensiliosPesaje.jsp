<%@taglib prefix="h" uri="http://java.sun.com/jsf/html" %>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core" %>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j" %>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <meta http-equiv="Expires" content="0">

            <meta http-equiv="Last-Modified" content="0">

            <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">

            <meta http-equiv="Pragma" content="no-cache">
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
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarAgregarComponentesProdVersionLimpiezaUtensiliosPesaje}"/>
                    <h:outputText styleClass="outputTextTituloSistema"   value="Agregar Limpieza de Utensilios de pesaje" />
                    <br/>
                        <rich:panel headerClass="headerClassACliente" style="width:50%">
                            <f:facet name="header">
                                <h:outputText value="Datos del Producto"/>

                            </f:facet>
                            <h:panelGrid columns="3" headerClass="headerClassACliente">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nombreProdSemiterminado} " styleClass="outputText2"/>
                               <h:outputText value="Forma farmace�tica" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.forma.nombreForma} " styleClass="outputText2"/>
                               <h:outputText value="Nro Versi�n" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionBean.nroVersion} " styleClass="outputText2"/>
                               
                            </h:panelGrid>
                        </rich:panel>
                    
                    <rich:dataTable value="#{ManagedComponentesProdVersion.utensilioPesajeLimpiezaAgregarList}"
                                            var="data" id="dataAgregarLimpiezaUtensilio" 
                                            headerClass="headerClassACliente"  style="margin-top:1em !important">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Maquinaria<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Codigo" escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Equipo" escape="false"/>
                                    </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                               <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.nombreMaquina}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.codigo}"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.maquinaria.tiposEquiposMaquinaria.nombreTipoEquipo}"/>
                                </rich:column>
                        </rich:dataTable>
                        <div id="bottonesAcccion" class="barraBotones">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedComponentesProdVersion.guardarAgregarComponentesProdVersionLimpiezaUtensiliosPesaje_action}"
                                               onclick="if(!editarItems('form1:dataAgregarLimpiezaUtensilio')){return false;}"
                                               oncomplete="mostrarMensajeTransaccionEvento(function(){redireccionar('navegadorLimpiezaUtensiliosPesaje.jsf')})"/>
                            <a4j:commandButton value="Cancelar"  styleClass="btn" oncomplete="window.location.href='navegadorLimpiezaUtensiliosPesaje.jsf?dontsave='+(new Date()).getTime().toString()"/>
                        </div>   
                         
                </div>

               
              
            </a4j:form>

             
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
    </html>

</f:view>

