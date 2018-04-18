<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script type="text/javascript" src="../../../js/general.js" ></script>
            <style type="text/css">
                .cambioTipoProduccion
                {
                    background-color:#dddddd;
                    color: black;
                    font-weight: bold;
                    text-align: center;
                }
            </style>
            <script type="text/javascript">
                function validarCantidadesFraccion()
                {
                   var cantidadTotal = parseFloat(document.getElementById('formEditarFracciones:cantidadTotal').innerHTML);
                   var registros = document.getElementById("formEditarFracciones:dataMPfraccion").getElementsByTagName("tbody")[0];
                   var sumaTotal = 0;
                   for(var i=0;i<registros.rows.length;i++)
                   {
                       if(!validarMayorACero(registros.rows[i].cells[1].getElementsByTagName("input")[0]))
                       {
                           return false;
                       }
                       sumaTotal+=parseFloat(registros.rows[i].cells[1].getElementsByTagName("input")[0].value);
                   }
                   sumaTotal = (Math.round(sumaTotal*100)/100);
                   if(cantidadTotal!=sumaTotal)
                   {
                       alert("La suma de las cantidades es diferente a la CANTIDAD TOTAL.");
                       return false;
                   }
                   return true;
                }
            </script>
        </head>
        <body>
            <h:form id="form1" >
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarFormulaMaestraDelleMpVersion}"   />
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.tamanioLoteProduccion}" styleClass="outputText2" />
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                            <h:outputText value="Volumen teórico" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80' || ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.cantidadVolumen}" styleClass="outputText2" />
                            <h:outputText value=" #{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Volumen de dosificado" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.cantidadVolumenDeDosificado}"  styleClass="outputText2" />
                            <h:outputText value=" #{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Tolerancia Fabricación" styleClass="outputText2" style="font-weight:bold" />
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                            <h:panelGroup >
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.toleranciaVolumenfabricar}"  styleClass="outputText2" />
                            <h:outputText value=" %" styleClass="outputText2" />
                            </h:panelGroup>
                            
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPList}"
                                    var="data" id="dataDetalleFormula" style="margin-top:0.5em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:selectBooleanCheckbox onclick="seleccionarTodosCheckBox(this)"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Materia Prima"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad<br>Unitaria<br>Gramos" escape="false" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad<br>Total<br>Gramos" escape="false" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Densidad<br>Material<br>(g/ml)" escape="false" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad<br>por<br>lote"  escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad<br>Medida<br>Almacen"  escape="false" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nro<br>Fracciones"  escape="false" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad<br>Por Fracción<br>Gramos"  escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fracciones<br>Gramos"  escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Estado Material"  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fracciones"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column colspan="12" styleClass="cambioTipoProduccion" >
                                <h:outputText value="#{data.nombreTipoMaterialProduccion}"/>
                            </rich:column>
                            <rich:subTable value="#{data.formulaMaestraDetalleMPList}" var="subData">
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{subData.checked}"  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.materiales.nombreMaterial}" />
                                </rich:column>
                                <rich:column styleClass="fondoAmarillo tdRight" >
                                    <h:outputText value="#{subData.cantidadUnitariaGramos}">
                                        <f:convertNumber pattern="##0.000000" locale="en"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column styleClass="fondoAmarillo tdRight">
                                    <h:outputText value="#{subData.cantidadTotalGramos}">
                                        <f:convertNumber pattern="##0.00" locale="en"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.densidadMaterial}" rendered="#{subData.unidadesMedida.tipoMedida.codTipoMedida!=2}">
                                        <f:convertNumber pattern="##0.00#####"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column  styleClass="tdRight">
                                    <h:outputText value="#{subData.cantidad}" >
                                        <f:convertNumber pattern="####0.00" locale="en"/>s
                                    </h:outputText>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{subData.unidadesMedida.nombreUnidadMedida}" />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.formulaMaestraDetalleMPfraccionesListSize}" />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.cantidadMaximaMaterialPorFraccion}" rendered="#{subData.cantidadMaximaMaterialPorFraccion>0}" />
                                    <h:outputText value="N.A." rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}" />
                                </rich:column>
                                <rich:column styleClass="fondoAmarillo tdRight" >
                                    <h:dataTable value="#{subData.formulaMaestraDetalleMPfraccionesList}" columnClasses="tituloCampo"
                                                 var="val" id="zonasDetalle" style="width:100%;border:0px solid red;text-align:right;" width="100%" >
                                        <h:column>
                                            <h:outputText value="#{val.cantidad}" style="text-align:right;"  styleClass="outputText2">
                                                <f:convertNumber locale="en" pattern="####0.00"/>
                                            </h:outputText>
                                        </h:column>
                                    </h:dataTable>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.materiales.estadoRegistro.nombreEstadoRegistro}" />
                                </rich:column>
                                <rich:column>
                                    <a4j:commandLink rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}"
                                                     oncomplete="Richfaces.showModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp')"
                                                     reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
                                        <f:setPropertyActionListener target="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPBean}"
                                                                     value="#{subData}"/>
                                        <h:graphicImage url="../../../img/edit.jpg"/>
                                        <h:outputText value="Modificar<br>Fracciones" escape="false"/>
                                    </a4j:commandLink>
                                </rich:column>
                            </rich:subTable>
                        <rich:column colspan="2" >
                            <h:outputText value="Total:" styleClass="outputTextBold"/>
                        </rich:column>
                        <rich:column styleClass="tdRight">
                            <h:outputText value="#{data.cantidadUnitariaMaterialTotal}">
                                <f:convertNumber pattern="###0.000000" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadMaterialTotal}">
                                <f:convertNumber pattern="###0.00" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column colspan="8" >
                        </rich:column>
                    </rich:dataTable>

                    <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">
                        <div id="bottonesAcccion" class="barraBotones" >
                            <a4j:commandButton value="Agregar" styleClass="btn" oncomplete="redireccionar('agregarMaterialesFormulaMaestraDetalleMP.jsf')"/>
                            <a4j:commandButton value="Editar " styleClass="btn"  action="#{ManagedProductosDesarrolloVersion.seleccionarEditarFormulaMaestraDetalleMpAction}"
                                                onclick="if(!alMenosUno('form1:dataDetalleFormula')){return false;}"
                                                oncomplete="redireccionar('editarFormulaMaestraVersionMP.jsf')"/>
                            <a4j:commandButton onclick="if(!alMenosUno('form1:dataDetalleFormula')){return false;}else{if(!confirm('Esta seguro de eliminar el material?')){return false;}}"
                                                value="Eliminar"  styleClass="btn" 
                                                action="#{ManagedProductosDesarrolloVersion.eliminarFormulaMaestraDetalleMPAction}"
                                                oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se elimino el material');}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}');}"
                                                reRender="dataDetalleFormula"/>
                            <a4j:commandButton value="Volver"   styleClass="btn"  oncomplete="redireccionar('../../navegadorProductosDesarrolloEnsayos.jsf')"/>
                        </div>
                    </h:panelGroup>

                </div>
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
            <rich:modalPanel id="panelModificacionFraccionesFormulaMaestraDetalleMp"
                                minHeight="380"  minWidth="700"
                                height="380" width="700" zindex="30"
                                headerClass="headerClassACliente"
                                resizeable="false">
                   <f:facet name="header">
                       <h:outputText value="<center>Modificar Fracciones Materia Prima</center>" escape="false" />
                   </f:facet>
                   <a4j:form id="formEditarFracciones">
                       <center>
                       <h:panelGroup id="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
                           <rich:panel headerClass="headerClassACliente">
                               <h:panelGrid columns="3">
                                   <h:outputText value="Material" styleClass="outputTextBold"/>
                                   <h:outputText value="::" styleClass="outputTextBold"/>
                                   <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPBean.materiales.nombreMaterial}" styleClass="outputText2"/>
                                   <h:outputText value="Cantidad Total(g)" styleClass="outputTextBold"/>
                                   <h:outputText value="::" styleClass="outputTextBold"/>
                                   <h:outputText id="cantidadTotal" value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPBean.cantidadTotalGramos}" styleClass="outputText2"/>
                                </h:panelGrid>
                            </rich:panel>
                           <div style="margin-top:1em;height:160px; overflow-y:auto; overflow-x: hidden">
                               <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPBean.formulaMaestraDetalleMPfraccionesList}"
                                                var="data" id="dataMPfraccion" rowKeyVar="var"
                                                headerClass="headerClassACliente"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                                            <f:facet name="header">
                                                <rich:columnGroup>
                                                    <rich:column >
                                                        <h:outputText value="Nro<Br> Fracción" escape="false"/>
                                                    </rich:column>
                                                    <rich:column >
                                                        <h:outputText value="Cantidad<Br>Material<br>fracción" escape="false"/>
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Eliminar"/>
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                                <rich:column >
                                                    <h:outputText value="#{var+1}"/>
                                                </rich:column>
                                                <rich:column >    
                                                    <h:inputText value="#{data.cantidad}" onkeypress="valNum(event);" onblur="valorPorDefecto(this)" styleClass="inputText"
                                                                 id="inputNumero">
                                                        <f:convertNumber pattern="####0.00" locale="en"/>
                                                    </h:inputText>
                                                </rich:column>  
                                                <rich:column>
                                                    <a4j:commandButton styleClass="btn" value="Eliminar" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp"
                                                                       action="#{ManagedProductosDesarrolloVersion.eliminarFraccionDesviacionFormulaMaestraDetalleMpAction(var)}">
                                                    </a4j:commandButton>
                                                </rich:column>
                                    </rich:dataTable>
                                </div>
                                <center>
                                    <a4j:commandLink action="#{ManagedProductosDesarrolloVersion.agregarFraccionDesviacionFormulaMaestraDetalleMpAction}" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp" >
                                        <h:graphicImage url="../../../img/mas.png"/>
                                    </a4j:commandLink>
                                </center>
                       </h:panelGroup>
                       <a4j:commandButton value="Aceptar" action="#{ManagedProductosDesarrolloVersion.guardarFormulaMaestraFraccionesMpAction}" 
                                          onclick="if(!validarCantidadesFraccion()){return false;}"
                                          oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se modificaron las fracciones');Richfaces.hideModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp');}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}')}"
                                          styleClass="btn" reRender="dataDetalleFormula"/>
                       </center>
                   </a4j:form>
               </rich:modalPanel>
        </body>
    </html>

</f:view>

