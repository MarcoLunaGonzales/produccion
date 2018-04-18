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
                function editarVersion()
                {
                    var tabla=document.getElementById("form1:dataFormula");
                    var cont=0;
                    for(var i=0;i<tabla.rows.length;i++)
                    {
                        if((tabla.rows[i].cells[0].getElementsByTagName("input").length>0)&&tabla.rows[i].cells[0].getElementsByTagName("input").checked)
                        {
                            cont++;
                        }
                    }
                    if(cont==0)
                    {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                    }
                    if(cont>1)
                    {
                        alert('No puede seleccionar mas de un registro');
                        return false;
                    }
                    return true;
                }
    </script>
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraEnAprobacion}"   />
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:14px;"  value="Listado de Versiones de Formula Maestra En Aprobacion" />
                    
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionAprobarList}" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente"  style="margin-top:8px;"
                                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Creacion"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaModificacion}"  title="Fecha Creacion">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                            </h:outputText>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Personal Creacion"  />
                            </f:facet>
                            <h:outputText value="#{data.personalCreacion.nombrePersonal}" styleClass="outputText2"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Modificacion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposModificacionFormula.nombreTipoModificacionFormula}" styleClass="outputText2"/>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.componentesProd.tipoProduccion.nombreTipoProduccion}" styleClass="outputText2"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Formula"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoRegistro.nombreEstadoRegistro}" styleClass="outputText2"/>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Nro Version"  />
                            </f:facet>
                            <h:outputText value="#{data.nroVersion}"  title="Cantidad Lote" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  title="Cantidad Lote" />
                        </h:column>
                        
                        
                        
                    </rich:dataTable>
                <div align="center" style="margin-top:12px">
                    <a4j:commandButton value="Revisar Version"
                    action="#{ManagedVersionesFormulaMaestra.revisarVersionFormulaMaestra_action}" styleClass="btn" 
                    oncomplete="var a =Math.random();window.location.href='navegadorRevisarFormulaMaestra.jsf?a='+a"
                    reRender="dataFormula"/>
                </div>
                </div>
            </h:form>
            
        </body>
    </html>
    
</f:view>

