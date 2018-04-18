<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<html>
    <head>
        <title>SISTEMA</title>
        
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="STYLESHEET" type="text/css" href="../css/icons.css" />
        <script type="text/javascript" src="../js/general.js"></script>
        <script type="text/javascript">
            function validarCantidadesFraccion()
            {
                var cantidadTotal=parseFloat(document.getElementById('formEditarFracciones:cantidadTotal').innerHTML);
                var registros=document.getElementById("formEditarFracciones:dataMPfraccion").getElementsByTagName("tbody")[0];
                var sumaTotal=0;
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
        <f:view>
            
            <h:form id="form1"  >       
                <div align="center">                    
                    <h:outputText value="#{ManagedComponentesProdVersion.cargarModificarFormulaMaestraDetalleMpList}"   />
                    <h:outputText value="Modificar Fracciones de producto" styleClass="outputTextTituloSistema"/>
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nombre Producto" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionModificarFracciones.nombreProdSemiterminado}" styleClass="outputText2"/>
                            <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionModificarFracciones.tamanioLoteProduccion}" styleClass="outputText2"/>
                            <h:outputText value="Nro versión" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold"/>
                            <h:outputText value="#{ManagedComponentesProdVersion.componentesProdVersionModificarFracciones.nroVersion}" styleClass="outputText2"/>
                        </h:panelGrid>
                    </rich:panel>
                    <br/>
                    <rich:dataTable value="#{ManagedComponentesProdVersion.formulaMaestraDetalleMPList}"
                                    var="data" id="dataDetalleFormula" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente">
                            <f:facet name="header">
                                <rich:columnGroup>
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
                                    <a4j:commandLink rendered="#{subData.cantidadMaximaMaterialPorFraccion eq 0}"  styleClass="btn"
                                                        oncomplete="Richfaces.showModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp')"
                                                        reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
                                        <h:outputText styleClass="icon-pencil2"/>
                                        <h:outputText value="Modificar<br>Fracciones" escape="false"/>
                                        <f:setPropertyActionListener value="#{subData}" target="#{ManagedComponentesProdVersion.formulaMaestraDetalleMPModificarFracciones}"/>
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
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandLink styleClass="btn" oncomplete="redireccionar('navegadorComponentesProdVersion.jsf')">
                            <h:outputText styleClass="icon-undo2"/>
                            <h:outputText value="Volver"/>
                        </a4j:commandLink>
                    </div>
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
                                minHeight="380"  minWidth="450"
                                height="380" width="450" zindex="30"
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
                                        <h:outputText value="#{ManagedComponentesProdVersion.formulaMaestraDetalleMPModificarFracciones.materiales.nombreMaterial}" styleClass="outputText2"/>
                                        <h:outputText value="Cantidad Total(g)" styleClass="outputTextBold"/>
                                        <h:outputText value="::" styleClass="outputTextBold"/>
                                        <h:outputText id="cantidadTotal" value="#{ManagedComponentesProdVersion.formulaMaestraDetalleMPModificarFracciones.cantidadTotalGramos}" styleClass="outputText2"/>
                                     </h:panelGrid>
                                 </rich:panel>
                                <br/>
                                <a4j:commandLink styleClass="btn"  action="#{ManagedComponentesProdVersion.agregarFormulaMaestraDetalleMpFraccion_action}" reRender="contenidoModificacionFraccionesFormulaMaestraDetalleMp">
                                    <h:outputText styleClass="icon-plus"/>
                                    <h:outputText value="Agregar Fracción"/>
                                </a4j:commandLink>
                                <div style="height:190px; overflow-y:auto; overflow-x: hidden">
                                    <rich:dataTable value="#{ManagedComponentesProdVersion.formulaMaestraDetalleMPModificarFracciones.formulaMaestraDetalleMPfraccionesList}"
                                                     var="data" id="dataMPfraccion" rowKeyVar="var"
                                                     style="width:100%"
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
                                                       <rich:column >
                                                           <h:outputText value="Eliminar" escape="false"/>
                                                       </rich:column>
                                                   </rich:columnGroup>
                                               </f:facet>
                                                    <rich:column  styleClass="tdCenter">
                                                        <h:outputText value="#{var+1}"/>
                                                    </rich:column>
                                                    <rich:column styleClass="tdCenter">    
                                                        <h:inputText value="#{data.cantidad}" onkeypress="valNum(event);" onblur="valorPorDefecto(this)" styleClass="inputText">
                                                            <f:convertNumber pattern="####0.00" locale="en"/>
                                                        </h:inputText>
                                                    </rich:column>
                                                     <rich:column styleClass="tdCenter"> 
                                                         <a4j:commandLink rendered="#{var ne 0}" styleClass="btn" action="#{ManagedComponentesProdVersion.eliminarFormulaMaestraDetalleMpFraccion_action(data)}"
                                                                            reRender="dataMPfraccion">
                                                             <h:outputText styleClass="icon-bin"/>
                                                             <h:outputText value="Eliminar"/>
                                                         </a4j:commandLink>
                                                     </rich:column>

                                         </rich:dataTable>
                                     </div>
                            </h:panelGroup>
                            <br/>
                            <a4j:commandLink  action="#{ManagedComponentesProdVersion.guardarModificarFormulaMaestraDetalleMpFraccion_action}"
                                               onclick="if(!validarCantidadesFraccion()){return false;}"
                                               reRender="dataDetalleFormula" oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp');})" styleClass="btn">
                                <h:outputText styleClass="icon-floppy-disk"/>
                                <h:outputText value="Guardar"/>
                            </a4j:commandLink>
                            <a4j:commandLink oncomplete="Richfaces.hideModalPanel('panelModificacionFraccionesFormulaMaestraDetalleMp');" styleClass="btn"
                                             reRender="form1">
                                <h:outputText styleClass="icon-cross"/>
                                <h:outputText value="Cancelar"/>
                            </a4j:commandLink>
                        </center>
                    </a4j:form>
                </rich:modalPanel>
                <a4j:include viewId="../message.jsp" />
            </f:view>
        </body>
        
    </html>
    


