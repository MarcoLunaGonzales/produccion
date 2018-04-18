package componentesProducto;

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
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedComponentesProducto.cargarVersionesCompProd}"   />
                    <h3>Versiones de Producto Semiterminado</h3>
                    
                    
                    <br>    <br>
                    
                    <br><br>
                    <rich:dataTable value="#{ManagedComponentesProducto.componentesProdVersionesList}" var="data" id="dataCadenaCliente"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            
                        </rich:column >
                        
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Via Administración"  />
                            </f:facet>
                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                        </rich:column >
                        
                          <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadVolumen}" rendered="#{data.cantidadVolumen>0}">
                                <f:convertNumber pattern="###.##" locale="EN" />
                            </h:outputText>
                            <h:outputText value=" #{data.unidadMedidaVolumen.abreviatura}" rendered="#{data.cantidadVolumen>0}"/>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tolerancia Volumen a Fabricar"  />
                            </f:facet>
                            <h:outputText value="#{data.toleranciaVolumenfabricar}" rendered="#{data.toleranciaVolumenfabricar>0}" />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Concentración Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.concentracionEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Peso Envase Primario "  />
                            </f:facet>
                            <h:outputText value="#{data.pesoEnvasePrimario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Color Presentación Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.coloresPresentacion.nombreColor}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Sabor"  />
                            </f:facet>
                            <h:outputText value="#{data.saboresProductos.nombreSabor}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Reg. Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Emisión R.S."  />
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimientoRS}"  >
                                <%--f:convertDateTime pattern="dd/MM/yyyy"   /--%>
                            </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Vida Util"  />
                            </f:facet>
                            <h:outputText value="#{data.vidaUtil}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Tipo Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tipoProduccion.nombreTipoProduccion}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}" rendered="#{ManagedComponentesProducto.opcionPresPrim}" >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:outputText value="<a href=\"navegadorPresentacionesPrimarias.jsf?codigo=#{data.codCompprod}\" class='outputText2'>Presentaciones Primarias</a>"  escape="false" />
                        </rich:column>
                        <rich:column styleClass="#{data.columnStyle}" rendered="#{ManagedComponentesProducto.opcionPresSecun}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.editarPresentacionesSecundarias_action}"
                             value="Presentaciones Secundarias" />
                            
                        </rich:column>
                        
                    </rich:dataTable>
                    <br>
                        <a4j:commandButton  rendered="#{ManagedComponentesProducto.agregarEdicionProd}" styleClass="btn" oncomplete="var a=Math.random();window.location.href='agregar_componentesProductoVersion.jsf?a='+a;" value="Registrar"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Editar"  styleClass="btn"  action="#{ManagedComponentesProducto.actionEditarVersion}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarRs}" value="Editar R.S."  styleClass="btn"  action="#{ManagedComponentesProducto.editarRegistroSanitario_action}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarTipoProd}" value="Editar Produccion"  styleClass="btn" style="width='150px'" action="#{ManagedComponentesProducto.editarTipoProduccion_action}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Eliminar"  styleClass="btn"  action="#{ManagedComponentesProducto.eliminarComponenteProdVersion_action}"  onclick="return eliminarItem('form1:dataCadenaCliente');"/>
                    
                    
                </div>
                <!--cerrando la conexion-->
               
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

