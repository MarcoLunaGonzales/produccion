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
            <script type="text/javascript">
                function validadAlMenosUno(nombreTabla)
                {
                    var tabla=document.getElementById(nombreTabla);
                    var cont=0;
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                        {
                            cont++;
                        }
                    }
                    if(cont==0)
                    {
                        alert('No selecciono ningun registro');
                        return false;
                    }
                    return true;
                }
            </script>
        </head>
            
            <a4j:form id="form1"  >                
                <div align="center">                    
                    <h:outputText value="Revisión de Versiones de Productos" styleClass="outputTextBold" style="font-size:14px"/>
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarComponentesProdVersionAprobacion}"   />
                    <rich:dataTable value="#{ManagedComponentesProdVersion.componentesProdVersionAprobarList}"
                                    var="data" id="dataComponentesProdVersion"
                                    style="margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                            
                                <f:facet name="header">
                                    <rich:columnGroup>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Nombre<br>Producto<br>Semiterminado" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Nombre<br>Comercial" escape="false"/>
                                            </rich:column>
                                            <rich:column colspan="3" >
                                                <h:outputText value="Datos Registro Sanitario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3" >
                                                <h:outputText value="Forma Farmaceútica" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Estado" escape="false"/>
                                            </rich:column>
                                            
                                            <rich:column colspan="4">
                                                <h:outputText value="Datos Version" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Revisar"/>
                                            </rich:column>
                                            <rich:column rowspan="3">
                                                <h:outputText value="Devolver Versión"/>
                                            </rich:column>
                                            <rich:column rowspan="2" breakBefore="true">
                                                <h:outputText value="Registro<br>Sanitario" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Vida<br>Util" escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Fecha Venc.<br> R.S." escape="false"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Nro Version"/>
                                            </rich:column>
                                            <rich:column rowspan="2" >
                                                <h:outputText value="Fecha Creación"/>
                                            </rich:column>
                                            <rich:column colspan="2" >
                                                <h:outputText value="Colaboración"/>
                                            </rich:column>
                                            <rich:column breakBefore="true" >
                                                <h:outputText value="Personal"/>
                                            </rich:column>
                                            <rich:column >
                                                <h:outputText value="Estado<br>Personal" escape="false"/>
                                            </rich:column>
                                    </rich:columnGroup>
                                </f:facet>
                             <rich:subTable var="subData" value="#{data.componentesProdVersionModificacionList}" rowKeyVar="rowkey">
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nombreProdSemiterminado}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.producto.nombreProducto}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.regSanitario}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.vidaUtil}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.fechaVencimientoRS}">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.forma.nombreForma}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}" />
                                    </rich:column>
                                    
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.nroVersion}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <h:outputText value="#{data.fechaModificacion}" >
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.personal.nombrePersonal}" />
                                        <h:inputHidden value="#{subData.personal.codPersonal}"/>
                                    </rich:column>
                                    <rich:column >
                                        <h:outputText value="#{subData.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}" />
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <a4j:commandButton value="Revisar" styleClass="btn"
                                                           oncomplete="redireccionar('navegadorRevisarComponentesProdVersion.jsf')">
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionRevisar}"/>
                                        </a4j:commandButton>
                                    </rich:column>
                                    <rich:column rowspan="#{data.componentesProdVersionModificacionListSize}"  rendered="#{rowkey eq 0}">
                                        <a4j:commandButton value="Devolver Versión" styleClass="btn"
                                                           action="#{ManagedComponentesProdVersion.seleccionarDevolverVersionAction}"
                                                           reRender="contenidoDevolverVersion"
                                                           oncomplete="Richfaces.showModalPanel('panelDevolverVersion');">
                                            <f:setPropertyActionListener value="#{data}" target="#{ManagedComponentesProdVersion.componentesProdVersionRevisar}"/>
                                        </a4j:commandButton>
                                    </rich:column>
                            </rich:subTable>
                    </rich:dataTable>
                        
                </div>
                
            </a4j:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
            <rich:modalPanel id="panelDevolverVersion"  minHeight="250"  minWidth="500"
                                     height="250" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="<center>Devolver versión a usuario</center>" escape="false"/>
                        </f:facet>
                <a4j:form id="form2">
                        <h:panelGroup id="contenidoDevolverVersion">
                            <div align="center">
                                <rich:dataTable  value="#{ManagedComponentesProdVersion.componentesProdVersionRevisar.componentesProdVersionModificacionList}"
                                         width="100%"  var="data"
                                         headerClass="headerClassACliente" style="width:80%"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                         id="dataPersonalDevolver"  align="center">
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value=""/>
                                    </f:facet>
                                    <h:selectBooleanCheckbox value="#{data.checked}" id="checkPersonal"/>
                                </rich:column>
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Personal"/>
                                    </f:facet>
                                    <h:outputLabel value="#{data.personal.nombreCompletoPersonal}" for="checkPersonal"/>
                                </rich:column>
                                
                            </rich:dataTable>
                            
                            <a4j:commandButton onclick="if(!validadAlMenosUno('form2:dataPersonalDevolver')){return false;}"
                                    reRender="dataComponentesProdVersion" value="Devolver Versión" action="#{ManagedComponentesProdVersion.devolverVersionPersonal_action}"
                                    oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelDevolverVersion');})" styleClass="btn" />
                            <a4j:commandButton value="Cancelar" style="margin-top:1em;" oncomplete="Richfaces.hideModalPanel('panelDevolverVersion');" styleClass="btn" />

                            </div>
                        </h:panelGroup>
                                
                        
                        
                </a4j:form>
            </rich:modalPanel>
           
    </html>
    
</f:view>

