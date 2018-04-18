<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" /> 
            <script src="../../js/general.js"></script>
            <script>
                function validadAgregarModulos()
                {
                    var tabla=document.getElementById("form1:dataAreasInstalacionesAgregar").getElementsByTagName("tbody")[0];
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        {
                            if(!validarRegistroNoVacio(tabla.rows[i].cells[2].getElementsByTagName("input")[0]))
                            {
                                console.log('fale');
                                return false;
                            }
                        }
                    }
                    return true;
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1"  >
                <div align="center" class="outputText2">
                <span class="outputTextTituloSistema">Agregar Modulo Instalación</span>
                <h:outputText value="#{ManagedAreasInstalaciones.cargarAgregarAreasInstalacionesModulos}"/>
                
                    <rich:panel headerClass="headerClassACliente" style="width:70%">
                        <f:facet name="header">
                            <h:outputText value="Modulos"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Código Instalación" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.codigo}" styleClass="outputText2"/>
                            <h:outputText value="Area" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText value="Nombre" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedAreasInstalaciones.areasInstalacionesBean.nombreAreaInstalacion}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    <br>
                    <rich:dataTable value="#{ManagedAreasInstalaciones.areasInstalacionesModuloAgregarList}"
                                    var="data" id="dataAreasInstalacionesAgregar" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Módulo"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Código"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.modulosInstalaciones.nombreModuloInstalacion}"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.codigo}" styleClass="inputText"/>
                        </rich:column>
                    </rich:dataTable>
                    <br>
                    <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedAreasInstalaciones.guardarAgregarAreasInstalacionModulos_action}"
                                       onclick="if(!validadAgregarModulos()){return false;}"
                                       oncomplete="if(#{ManagedAreasInstalaciones.mensaje eq '1'}){alert('Se registraron las areas instalaciones');window.location.href='navegadorAreasInstalacionesModulos.jsf?save='+(new Date()).getTime().toString();}
                                       else{alert('#{ManagedAreasInstalaciones.mensaje}');}"/>
                    <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorAreasInstalacionesModulos.jsf?cancel='+(new Date()).getDate().toString()"/>
                    
                    
                    
                </div>
                
                
            </a4j:form>
        </body>
    </html>
    
</f:view>

