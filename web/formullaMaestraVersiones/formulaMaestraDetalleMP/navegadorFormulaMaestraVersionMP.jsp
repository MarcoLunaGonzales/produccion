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
                function getCodigoES(codigoM){
                    location='navegador_detalle_fracciones.jsf?codigoM='+codigoM;
                }
                function validarCantidadesFraccion()
                {
                   var cantidadTotal=parseFloat(document.getElementById('formEditarFracciones:cantidadTotal').innerHTML);
                   var registros=document.getElementById("formEditarFracciones:dataMPfraccion").getElementsByTagName("tbody")[0];
                   var sumaTotal=0;
                   for(var i=0;i<registros.rows.length;i++)
                   {
                       if(!validarMayorACero(registros.rows[i].cells[2].getElementsByTagName("input")[0]))
                       {
                           return false;
                       }
                       sumaTotal+=parseFloat(registros.rows[i].cells[2].getElementsByTagName("input")[0].value);
                   }
                   sumaTotal = (Math.round(sumaTotal*100)/100);
                   if(cantidadTotal!=sumaTotal)
                   {
                       alert("La suma de las cantidades es diferente a la CANTIDAD TOTAL.");
                       return false;
                   }
                   return true;
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
            </script>
        </head>
        <body>
            <h:form id="form1" >
                <div align="center">
                     <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraDetalleMPVersion}"   />
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
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.cantidadLote}" styleClass="outputText2" />
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                            <h:outputText value="Volumen teórico" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80' || ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.cantidadVolumen}" styleClass="outputText2" />
                            <h:outputText value=" #{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Volumen de dosificado" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.cantidadVolumenDeDosificado}"  styleClass="outputText2" />
                            <h:outputText value=" #{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Tolerancia Fabricación" styleClass="outputText2" style="font-weight:bold" />
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                            <h:panelGroup >
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.toleranciaVolumenfabricar}"  styleClass="outputText2" />
                            <h:outputText value=" %" styleClass="outputText2" />
                            </h:panelGroup>
                            
                        </h:panelGrid>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPList}"
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
                                        <f:convertNumber pattern="#,##0.00" locale="en"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.densidadMaterial}" rendered="#{subData.unidadesMedida.tipoMedida.codTipoMedida!=2}">
                                        <f:convertNumber pattern="#,##0.00#####"/>
                                    </h:outputText>
                                </rich:column>
                                <rich:column  styleClass="tdRight">
                                    <h:outputText value="#{subData.cantidad}" >
                                        <f:convertNumber pattern="#,###0.00" locale="en"/>s
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
                                                <f:convertNumber locale="en" pattern="##,##0.00"/>
                                            </h:outputText>
                                        </h:column>
                                    </h:dataTable>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="#{subData.materiales.estadoRegistro.nombreEstadoRegistro}" />
                                </rich:column>
                                <rich:column>
                                    <a4j:commandLink action="#{ManagedVersionesFormulaMaestra.seleccionesFormulaMaestraDetalleMPVersion_action}"
                                                     rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}"
                                                    oncomplete="Richfaces.showModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp')"
                                                    reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
                                        <f:param name="codTipoMaterial" value="#{data.codTipoMaterialProduccion}"/>
                                        <f:param name="codMaterial" value="#{subData.materiales.codMaterial}"/>
                                        <h:graphicImage url="../../img/edit.jpg"/>
                                        <h:outputText value="Modificar<br>Fracciones" escape="false"/>
                                    </a4j:commandLink>
                                </rich:column>
                            </rich:subTable>
                        <rich:column colspan="2" >
                            <h:outputText value="Total:" styleClass="outputTextBold"/>
                        </rich:column>
                        <rich:column styleClass="tdRight">
                            <h:outputText value="#{data.cantidadUnitariaMaterialTotal}">
                                <f:convertNumber pattern="#,##0.000000" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadMaterialTotal}">
                                <f:convertNumber pattern="##,##0.00" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column colspan="8" >
                            <h:outputText value = "<b>Cantidad de items :</b> #{data.formulaMaestraDetalleMPListSize}"
                                          escape="false"/>
                        </rich:column>
                    </rich:dataTable>

                    <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.estadoVersionFormulaMaestra.codEstadoVersionFormulaMaestra!='2'}">
                        <div id="bottonesAcccion" class="barraBotones" >
                            <a4j:commandButton value="Agregar" action="#{ManagedVersionesFormulaMaestra.agregarFormulaMaestraDetalleMp_action}"
                                               styleClass="btn" oncomplete="redireccionar('agregarMaterialesFormulaMaestraDetalleMP.jsf')"/>
                            <a4j:commandButton value="Agregar Recubrimiento" action="#{ManagedVersionesFormulaMaestra.agregarFormulaMaestraDetalleMpRecubrimiento_action}"
                                               styleClass="btn" oncomplete="redireccionar('agregarMaterialesFormulaMaestraDetalleMP.jsf')"/>
                            <a4j:commandButton value="Editar "    styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.editarFormulaMaestraDetalleMp_action}"
                            onclick="if(!alMenosUno('form1:dataDetalleFormula')){return false;}"
                            oncomplete="redireccionar('editarFormulaMaestraVersionMP.jsf')"/>
                            <a4j:commandButton onclick="if(!alMenosUno('form1:dataDetalleFormula')){return false;}else{if(!confirm('Esta seguro de eliminar el material?')){return false;}}" value="Eliminar"  styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.eliminarFormulaMaestraDetalleMP_action}"
                            oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se elimino el material');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"
                            reRender="dataDetalleFormula"/>
                            <a4j:commandButton value="Cancelar"   styleClass="btn"  oncomplete="retornarNavegadorFm(#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.tiposModificacionProducto.codTipoModificacionProducto});"/>
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
                                   <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.materiales.nombreMaterial}" styleClass="outputText2"/>
                                   <h:outputText value="Cantidad Total(g)" styleClass="outputTextBold"/>
                                   <h:outputText value="::" styleClass="outputTextBold"/>
                                   <h:outputText id="cantidadTotal" value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.cantidadTotalGramos}" styleClass="outputText2"/>
                                   <%--h:outputText value="Cantidad Por Fraccion" styleClass="outputTextBold"/>
                                   <h:outputText value="::" styleClass="outputTextBold"/>
                                   <h:panelGroup>
                                       <h:inputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.cantidadMaximaMaterialPorFraccion}" styleClass="inputText"/>
                                       <a4j:commandButton value="Recalcular" styleClass="btn" action="#{ManagedVersionesFormulaMaestra.recalcularFraccionesDesviacionFormulaMaestraDetalleMp_action}"
                                                           reRender="dataMPfraccion"/>
                                   </h:panelGroup--%>
                                </h:panelGrid>
                            </rich:panel>
                           <div style="margin-top:1em;height:160px; overflow-y:auto; overflow-x: hidden">
                               <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMPBean.formulaMaestraDetalleMPfraccionesList}"
                                                var="data" id="dataMPfraccion" rowKeyVar="var"
                                                headerClass="headerClassACliente"
                                                onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                                          <f:facet name="header">
                                              <rich:columnGroup>
                                                  <rich:column >
                                                      <h:outputText value=""/>
                                                  </rich:column>
                                                  <rich:column >
                                                      <h:outputText value="Nro<Br> Fracción" escape="false"/>
                                                  </rich:column>
                                                  <rich:column >
                                                      <h:outputText value="Cantidad<Br>Material<br>fracción" escape="false"/>
                                                  </rich:column>
                                              </rich:columnGroup>
                                          </f:facet>
                                              <rich:column>
                                                  <h:selectBooleanCheckbox value="#{data.checked}"/>
                                              </rich:column>
                                              <rich:column >
                                                  <h:outputText value="#{var+1}"/>
                                              </rich:column>
                                              <rich:column >    
                                                  <h:inputText value="#{data.cantidad}" onkeypress="valNum(event);" onblur="valorPorDefecto(this)" styleClass="inputText">
                                                      <f:convertNumber pattern="####0.00" locale="en"/>
                                                  </h:inputText>
                                              </rich:column>
                                    </rich:dataTable>
                                </div>
                                <center>
                                    <a4j:commandLink action="#{ManagedVersionesFormulaMaestra.agregarFraccionDesviacionFormulaMaestraDetalleMp_action}" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp" >
                                            <h:graphicImage url="../../img/mas.png"/>
                                        </a4j:commandLink>
                                        <a4j:commandLink action="#{ManagedVersionesFormulaMaestra.eliminarFraccionDesviacionFormulaMaestraDetalleMp_action}" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp" >
                                            <h:graphicImage url="../../img/menos.png"/>
                                        </a4j:commandLink>
                                </center>
                       </h:panelGroup>
                       <a4j:commandButton value="Aceptar" action="#{ManagedVersionesFormulaMaestra.completarEditarFraccionesFormulaMaestraDetalleMp_action}" 
                                          onclick="if(!validarCantidadesFraccion()){return false;}"
                                          oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se modificaron las fracciones');Richfaces.hideModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp');}else{alert('#{ManagedVersionesFormulaMaestra.mensaje}')}" styleClass="btn" reRender="dataDetalleFormula"/>
                       </center>
                   </a4j:form>
               </rich:modalPanel>
        </body>
    </html>

</f:view>

