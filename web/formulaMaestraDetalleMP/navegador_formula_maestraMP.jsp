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
            <script type="text/javascript">
                function getCodigoES(codigoM){
                    location='navegador_detalle_fracciones.jsf?codigoM='+codigoM;
                }
            </script>
        </head>
        <body>
            <h:form id="form1">

                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleMP.obtenerCodigo}"   />

                </div>
                <div align="center">

                    Materia Prima de: <h:outputText value="#{ManagedFormulaMaestraDetalleMP.nombreComProd}"   />
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                    <br><br>

                    <table width="25%" align="center" class="outputText2">
                        <tr>
                            <td> Material Reactivo : </td>
                            <td bgcolor="#C5F7C8" width="20%" >&nbsp;</td>
                        </tr>
                    </table>
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMPList}" var="data" id="dataAreasDependientes" 
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
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText rendered="#{data.swSi}" style="background-color: #C5F7C8" value="#{data.materiales.nombreMaterial}"  />
                            <h:outputText rendered="#{data.swNo}" value="#{data.materiales.nombreMaterial}" />
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
                                <h:outputText value="Fracciones"  />
                            </f:facet>
                            <h:outputText value="#{data.nroPreparaciones}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Fracciones Detalle"  />
                            </f:facet>
                            <h:dataTable value="#{data.fraccionesDetalleList}" columnClasses="tituloCampo"
                                         var="val" id="zonasDetalle" style="width:100%;border:0px solid red;text-align:right;" width="100%" >
                                <h:column>
                                    <h:outputText value="#{val.cantidad}" style="text-align:right;"  ><f:convertNumber maxFractionDigits="2" /></h:outputText>
                                </h:column>
                                <h:column>
                                    <h:outputText value="#{val.tiposMaterialProduccion.nombreTipoMaterialProduccion}" style="text-align:right;"  >
                                    </h:outputText>
                                </h:column>
                            </h:dataTable>
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Fracciones Detalle"  />
                            </f:facet>
                            <h:outputText value="<a  onclick=\"getCodigoES('#{data.materiales.codMaterial}');\" style='cursor:hand;text-decoration:underline' >Modificar Fracciones</a>  "  escape="false"  />
                        </h:column>

                    </rich:dataTable>

                    <br>
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionAgregar}"/>
                    <h:commandButton value="Editar "    styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionEditar}" onclick="return editarItem('form1:dataCliente'); "/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.actionEliminar}"  onclick="return eliminarItem('form1:dataCliente'); "/>
                    <h:commandButton value="Cancelar"   styleClass="btn"  action="navegadorFormulaMaestra"/>


                </div>

                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraDetalleMP.closeConnection}"  />

            </h:form>

        </body>
    </html>

</f:view>

