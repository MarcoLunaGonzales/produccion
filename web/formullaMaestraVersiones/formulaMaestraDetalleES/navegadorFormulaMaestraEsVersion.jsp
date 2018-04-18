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
                function verReporteCambiosVersion(codFormulaMaestraEsVersion)
                {
                    var url="empaqueSecundarioJasper/reporteComparacionVersionesEmpaqueSecundario.jsf?codFormulaMaestraEsVersion="+codFormulaMaestraEsVersion+"&data="+(new Date()).getTime().toString();
                    openPopup(url);
                }
                function openPopup(url)
                {
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function anexoEmpaqueSecundario(codVersion,codFormulaMaestraEsVersion)
                {
                    var url="empaqueSecundarioJasper/reporteAnexo.jsf?codLoteProduccion=H"+codVersion+"&codProgramaProd=0&codFormulaMaestraEsVersion="+codFormulaMaestraEsVersion+"&data="+(new Date()).getTime().toString();
                    openPopup(url);
                }
                function validarRegistroControlCambios()
                {
                    return validarRegistroNoVacio(document.getElementById("formRegistrarControlCambio:propositoCambio"));
                }
                function retornarNavegadorFm(codTipoModificacionProducto)
                {
                    var url="";
                    switch(codTipoModificacionProducto)
                    {
                        case 1:
                        {
                            url="navegadorNuevosComponentesProd";
                            break;
                        }
                        case 2:
                        {
                            url="navegadorNuevosTamaniosLote";
                            break;
                        }
                        case 3:
                        {
                            url="navegadorComponentesProdVersion";
                            break;
                        }
                        case 4:
                        {
                            url="navegadorNuevosComponentesProd";
                            break;
                        }
                    }
                    window.location.href="../../componentesProdVersion/"+url+".jsf?fm="+(new Date()).getTime().toString();
                }
                function validarPersonalRegistro(codPersonalAsignado)
                {
                    if(codPersonalAsignado<=0)
                    {
                        alert('No se puede modificar el empaque secundario ya que no se encuentra registrado para modificación');
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                    return false;
                }
            </script>
            
        </head>
        <body>
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraEsVersion.cargarFormulaMaestraEsVersion}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tamanioLoteProduccion}" styleClass="outputText2" />
                            <h:outputText value="Nro. Versión Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nroVersion}" styleClass="outputText2" />
                        </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionList}" var="data" 
                                    id="dataFormulaMaestraEsVersion" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    binding="#{ManagedFormulaMaestraEsVersion.formulaMaestraEsVersionDataTable}"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rendered="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd!=1&&ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd!=5}">
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Nro Cambio"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Personal Creación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Estado Modificación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Creación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Envio Aprobación"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Fecha Inicio Vigencia"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Observación"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Detalle"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Reporte de Cambios"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Anexo"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column rendered="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd!=1&&ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd!=5}">
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq '1'}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nroVersion}.#{data.nroVersion}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.personal.nombrePersonal}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.estadosVersionComponentesProd.nombreEstadoVersionComponentesProd}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaCreacion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaEnvioAprobacion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.fechaAprobacion}">
                                <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.observacion}"/>
                        </rich:column>
                        <rich:column >
                            <a4j:commandLink action="#{ManagedFormulaMaestraEsVersion.seleccionarFormulaMaestraEsVersion_action}"
                                             rendered="#{(ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto eq '4'&&ManagedComponentesProdVersion.controlPresentacionNuevaGenerico)||(ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto eq '1'&&ManagedComponentesProdVersion.controlNuevoProducto)||(ManagedComponentesProdVersion.controlEmpaqueSecundario&&data.estadosVersionComponentesProd.codEstadoVersionComponenteProd eq '1')}"
                                             onclick="if(!validarPersonalRegistro(#{data.personal.codPersonal})){return false;}"
                                oncomplete="window.location.href='navegadorFormulaMaestraDetalleEsVersion.jsf?deta='+(new Date()).getTime().toString();">
                                <h:graphicImage url="../../img/EmpSec.png" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center">
                            <a4j:commandLink oncomplete="verReporteCambiosVersion('#{data.codFormulaMaestraEsVersion}');">
                                <h:graphicImage url="../../img/reporteConsolidado.png" alt="Reporte Consolidado de Versiones"/>
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column style="text-align:center">
                            <a4j:commandLink oncomplete="anexoEmpaqueSecundario('#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.codVersion}','#{data.codFormulaMaestraEsVersion}');" >
                                <h:graphicImage url="../../img/anexos.jpg"  alt="Anexos" />
                            </a4j:commandLink>
                        </rich:column>
                        
                    </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Crear Nuevo Cambio" styleClass="btn" reRender="contenidoRegistroControlCambios"
                                       rendered="#{ManagedComponentesProdVersion.componentesProdBean.colorFila eq '2' && ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd==2&&ManagedComponentesProdVersion.controlEmpaqueSecundario}"
                                       oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){Richfaces.showModalPanel('panelRegistroControlCambios');}
                                       else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}"
                                       action="#{ManagedFormulaMaestraEsVersion.agregarVersionPorControlDeCambios}"/>
                    <a4j:commandButton value="Eliminar" styleClass="btn" reRender="dataFormulaMaestraEsVersion"
                                       rendered="#{ManagedComponentesProdVersion.componentesProdBean.colorFila eq '2' && ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd==2&&ManagedComponentesProdVersion.controlEmpaqueSecundario}"
                                       oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se elimino el cambio de empaque secundario');}
                                       else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}"
                                       action="#{ManagedFormulaMaestraEsVersion.eliminarFormulaMaestraEsVersionControlDeCambios_action}"/>
                    <a4j:commandButton value="Enviar a Revisión" styleClass="btn" reRender="dataFormulaMaestraEsVersion"
                                       rendered="#{ManagedComponentesProdVersion.componentesProdBean.colorFila eq '2' && ManagedFormulaMaestraEsVersion.componentesProdVersionBean.estadosVersionComponentesProd.codEstadoVersionComponenteProd==2&&ManagedComponentesProdVersion.controlEmpaqueSecundario}"
                                       action="#{ManagedFormulaMaestraEsVersion.enviarAprobacionFormulaMaestraEsVersion_action}"
                                       oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Los cambios de empaque secundario fueron enviados a aprobación satisfactoriamente');}
                                       else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}')}"/>
                    <a4j:commandButton value="Volver"   styleClass="btn" oncomplete="retornarNavegadorFm(#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tiposModificacionProducto.codTipoModificacionProducto});"/>
                    
                    
                </div>
                
                
            </h:form>
            <rich:modalPanel id="panelRegistroControlCambios" minHeight="240"  minWidth="600"
                                 height="240" width="600"
                                 zindex="4"
                                 headerClass="headerClassACliente"
                                 resizeable="false" style="overflow :auto" >
                    <f:facet name="header">
                        <h:outputText value="Registro Control de Cambios"/>
                    </f:facet>
                    <a4j:form id="formRegistrarControlCambio">
                    <h:panelGroup id="contenidoRegistroControlCambios">
                        <div align="center">
                        <h:panelGrid columns="3">
                            <h:outputText value="Personal" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.registroControlCambios.personalRegistra.nombrePersonal}" styleClass="outputText2"/>
                            <h:outputText value="Area Empresa" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.registroControlCambios.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                            <h:outputText value="Proposito del Cambio" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:inputTextarea style="width:40em" value="#{ManagedFormulaMaestraEsVersion.registroControlCambios.propositoCambio}" styleClass="inputText" id="propositoCambio" rows="4">
                            </h:inputTextarea>
                        </h:panelGrid>

                                <a4j:commandButton onclick="if(!validarRegistroControlCambios()){return false;}"
                                                   styleClass="btn" reRender="dataFormulaMaestraEsVersion"
                                                   action="#{ManagedFormulaMaestraEsVersion.crearNuevaFormulaMaestraEsVersion_action}" value="Guardar" 
                                                   oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se registro el control de cambios y se habilitaron los cambios de empaque secundario');Richfaces.hideModalPanel('panelRegistroControlCambios');}
                                                   else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}"/>
                                <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="Richfaces.hideModalPanel('panelRegistroControlCambios');"/>
                            
                            </div>
                    </h:panelGroup>
                    </a4j:form>
            </rich:modalPanel>
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

