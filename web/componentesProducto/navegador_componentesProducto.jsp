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
                    
                    <h:outputText value="#{ManagedComponentesProducto.obtenerCodigo}"   />
                    <h3>Información de Producto Semiterminado</h3>   
                    <div align="center">
                        <h:panelGrid columns="3"   cellpadding="0"  cellspacing="2" >
                            <h:outputText value="Leyenda:"  styleClass="tituloCampo"  style="vertical-align:cente;text-align:center" />
                            <h:outputText value="Producto Compuesto"  styleClass="tituloCampo"   />
                            <h:outputText value=""  styleClass="codcompuestoprod"  style="width:100px;border:1px solid #000000;" />
                        </h:panelGrid>
                    </div>
                    
                    <br>    <br>
                    <div align="center">
                        <h:outputText value="Filtrar por Nombre Comercial" styleClass="outputText2" />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.producto.codProducto}" id="producto" valueChangeListener="#{ManagedComponentesProducto.filtrarProductos}"  >
                            <f:selectItems value="#{ManagedComponentesProducto.productosList}"  />
                            <a4j:support action="#{ManagedComponentesProducto.tiposProduccion_change}" event="onchange" reRender="dataCadenaCliente"/>
                        </h:selectOneMenu>
                        <br>
                        <h:outputText value="Filtrar por Estado" styleClass="outputText2" />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.estadoCompProd.codEstadoCompProd}" id="estados_compprod"   valueChangeListener="#{ManagedComponentesProducto.filtrarEstadosCompProd}"  >
                            <f:selectItems value="#{ManagedComponentesProducto.estadosCompProdList}"  />
                            <a4j:support action="#{ManagedComponentesProducto.tiposProduccion_change}" event="onchange" reRender="dataCadenaCliente"/>
                        </h:selectOneMenu>
                        <br>
                        <h:outputText value="Filtrar por Tipo de Producción" styleClass="outputText2" />
                        <h:selectOneMenu styleClass="inputText" value="#{ManagedComponentesProducto.componentesProdbean.tipoProduccion.codTipoProduccion}" id="codTipoProd" >
                            <f:selectItems value="#{ManagedComponentesProducto.tiposProduccionList}" />
                            <a4j:support action="#{ManagedComponentesProducto.tiposProduccion_change}" event="onchange" reRender="dataCadenaCliente"/>
                        </h:selectOneMenu>
                        <!--     <br>    <br> -->
                    </div>
                    <br><br> 
                    <rich:dataTable value="#{ManagedComponentesProducto.componentesProductoList}" var="data" id="dataCadenaCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"
                                    binding = "#{ManagedComponentesProducto.componentesProdDataTable}">
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            
                        </rich:column >
                        
                        <%--rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column --%>
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Version"  />
                            </f:facet>
                            <h:outputText value="#{data.nroUltimaVersion}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                        
                        <%--rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Envase Primario"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"  />
                        </rich:column --%>
                        <%--rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen/Concentración "  />
                            </f:facet>
                            <h:outputText value="#{data.volumenPesoEnvasePrim}"  />
                        </rich:column--%>
                        <rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Via Administración"  />
                            </f:facet>
                            <h:outputText value="#{data.viasAdministracionProducto.nombreViaAdministracionProducto}"  />
                        </rich:column >
                        <%--rich:column styleClass="#{data.columnStyle}">
                            <f:facet name="header">
                                <h:outputText value="Volúmen Envase Primario Anterior"  />
                            </f:facet>
                            <h:outputText value="#{data.volumenEnvasePrimario}"  />
                        </rich:column --%>
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
                        
                        <rich:column styleClass="#{data.columnStyle}" rendered="#{ManagedComponentesProducto.usuario.codAreaEmpresaGlobal eq '77'}" >
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
                        <rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="Versiones"  />
                            </f:facet>
                            
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.verVersionesCompProd_action}"
                             >
                                 <h:graphicImage url="../img/detalle.jpg" title="versiones"/>
                                 </h:commandLink>
                        </rich:column>
                        <%--rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="analisis Fisico"  />
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.agregarAnalisisFisico_action}"
                             >
                                 <h:graphicImage url="../img/detalle.jpg" title="analisis físico"/>
                                 </h:commandLink>

                        </rich:column>

                          <rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="analisis Químico"  />
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.agregarAnalisisQuimico_Action}"
                            >
                                <h:graphicImage url="../img/detalle.jpg" title="analisis químico"/>
                            </h:commandLink>

                        </rich:column>
                         <rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value="analisis Microbiologico"  />
                            </f:facet>
                            <h:commandLink styleClass="outputText2" action="#{ManagedComponentesProducto.agregarAnalisisMicrobiologia_Action}"
                             >
                                 <h:graphicImage url="../img/detalle.jpg" title="analisis microbiologico"/>
                                 </h:commandLink>

                        </rich:column--%>
                        <%--rich:column styleClass="#{data.columnStyle}" >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:outputText value="<a href=\"navegadorAccionesTerapeuticas.jsf?codigo=#{data.codCompprod}\" target=\"_blank\" >Acciones <br> Terapeúticas</a>"  escape="false" />
                        </rich:column--%>

                    </rich:dataTable>
                    <br>
                    <a4j:commandButton  rendered="#{ManagedComponentesProducto.agregarEdicionProd}" styleClass="btn" oncomplete="var a=Math.random();window.location.href='agregar_componentesProducto.jsf?a='+a;" value="Registrar"/>
                    <a4j:commandButton  styleClass="btn" oncomplete="var a=Math.random();window.location.href='agregar_componentesProducto.jsf?a='+a;" value="Registrar"/>
                    <a4j:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Editar"  styleClass="btn"  action="#{ManagedComponentesProducto.modificarEstadoComponentesProd_action}" oncomplete="location='modificar_EstadocomponentesProducto.jsf'" />
                    <%--h:commandButton rendered="#{ManagedComponentesProducto.editarRs}" value="Editar R.S."  styleClass="btn"  action="#{ManagedComponentesProducto.editarRegistroSanitario_action}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarTipoProd}" value="Editar Produccion"  styleClass="btn" style="width='150px'" action="#{ManagedComponentesProducto.editarTipoProduccion_action}" onclick="return editarItem('form1:dataCadenaCliente');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Eliminar"  styleClass="btn"  action="#{ManagedComponentesProducto.actionEliminar}"  onclick="return eliminarItem('form1:dataCadenaCliente');"/--%>
                    
                </div>
                <!--cerrando la conexion-->
               
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

