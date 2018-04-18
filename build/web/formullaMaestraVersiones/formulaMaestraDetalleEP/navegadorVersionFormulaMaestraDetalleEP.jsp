<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script>
             function almenosUno(nombreTabla,soloUno)
                {
                    var tabla=document.getElementById(nombreTabla);
                    var cont=0;
                    for(var i=1;i<tabla.rows.length;i++)
                    {
                        if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked)
                        {
                            cont++;
                        }
                    }
                    if(cont==0)
                     {
                        alert('Debe seleccionar al menos un registro');
                        return false;
                     }
                    if(cont>1&&soloUno)
                    {
                        alert('Solo puede seleccionar un registro');
                        return false;
                    }
                    return true;
                }
            </script>
        </head>
        <body >
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraDetalleEpVersion}"   />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                            
                        </h:panelGrid>
                        <rich:panel headerClass="headerClassACliente" style="min-width:50%;max-width:90%">
                            <f:facet name="header">
                                <h:outputText value="Datos Presentacion Primaria"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Envase Primario" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.envasesPrimarios.nombreEnvasePrim}" styleClass="outputText2" />
                                <h:outputText value="Cantidad" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.cantidad}" styleClass="outputText2" />
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraEPBean.presentacionesPrimarias.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2" />
                            </h:panelGrid>
                        </rich:panel>
                    </rich:panel>
                   
                   <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleEPList}" var="data" id="dataMaterialesMP"
                                    style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                        </h:column>
                    
                        
                    </rich:dataTable>
                    
                    <br>
                    <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">
                        <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='agregarFormulaMaestraDetalleEpVersion.jsf?a='+a"/>
                        
                        <a4j:commandButton value="Cancelar"   styleClass="btn"  oncomplete="var a=Math.random();window.location.href='navegadorFormulaMaestraEP.jsf?cancel='+a;"/>
                    </h:panelGroup>
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                
                
            </h:form>
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

