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

            <script  type="text/javascript">
            function buscarTexto()
            {
                var tablaBuscar = document.getElementById('form2:detalle');
                var textoBuscar= document.getElementById('productoBuscar').value.toLowerCase();
                var encontrado=false;
                for (var i = 2; i < tablaBuscar.rows.length; i++)
                {
                    encontrado=false;
                    if (textoBuscar.length == 0 || (tablaBuscar.rows[i].cells[0].innerHTML.toLowerCase().indexOf(textoBuscar) > -1))
                    {
                        encontrado= true;
                    }
                    
                    if(encontrado)
                    {
                        tablaBuscar.rows[i].style.display = '';
                    } else {
                        tablaBuscar.rows[i].style.display = 'none';
                    }
                }
            }
            function sumaCantidadTotalLote()
            {
                var tablaLotes=document.getElementById("form1:dataProgramaProduccion").getElementsByTagName("tbody")[0];
                var cantidadTotal = 0.0;
                for(var i=0;i<tablaLotes.rows.length;i++)
                {
                    if(!isNaN(tablaLotes.rows[i].cells[2].getElementsByTagName("input")[0].value))
                    {
                        cantidadTotal += parseFloat(tablaLotes.rows[i].cells[2].getElementsByTagName("input")[0].value);
                    }
                }
                document.getElementById("form1:dataProgramaProduccion:cantidadTotalLote").innerHTML = cantidadTotal;
            }
             function validarRegistro()
             {
                if(!validarIntervaloValoresById('form1:nroLotes',1,10)){
                    return false;
                }
                 var tabla=document.getElementById("form1:dataProgramaProduccion").getElementsByTagName("tbody")[0];
                 var cantidadSuma=0;
                 for(var i=0;i<tabla.rows.length;i++){
                     cantidadSuma+=parseInt(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value);
                     if((!validarMayorACero(tabla.rows[i].cells[2].getElementsByTagName("input")[0])) 
                        || (!validarSeleccionMayorACero(tabla.rows[i].cells[4].getElementsByTagName("select")[0]))){
                         return false;
                     }
                 }
                 if(parseInt(document.getElementById("form1:cantidadLote").innerHTML)!=cantidadSuma)
                 {
                        alert('La suma de las cantidades no es igual a la cantidad oficial del lote');
                        return false;
                 }
                 return confirm('Esta seguro de registrar los lotes?');
                 
             }
         </script>
         <style>
             .seleccionado
             {
                 background-color:#98FB98;
             }
         </style>
        </head>
            <body onload="Richfaces.showModalPanel('panelAgregarFormulaCabecera')">

            
            <a4j:form id="form1" >
                <div align="center" >
                    <h:outputText value="#{ManagedProgramaProduccion.cargarAgregarProgramaProduccion}" />
                    <h:panelGroup id="contenidoAgregarLote">
                        <rich:panel headerClass="headerClassACliente"  style="width:80%" rendered="#{not empty ManagedProgramaProduccion.programaProduccionCabecera}">
                            <f:facet name="header">
                                <h:outputText value="Datos producto"/>
                            </f:facet>
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputTextBold" value="Producto"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabecera.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}" styleClass="outputText2"/>
                                <h:outputText styleClass="outputTextBold" value="Cantidad Lote Segun F.M."/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:outputText value="#{ManagedProgramaProduccion.programaProduccionCabecera.formulaMaestraVersion.cantidadLote}" styleClass="outputText2" id="cantidadLote"/>
                                <h:outputText styleClass="outputTextBold" value="Cantidad Lotes"/>
                                <h:outputText styleClass="outputTextBold" value="::"/>
                                <h:panelGroup id="contenidoNroLotes">
                                    <h:inputText value="#{ManagedProgramaProduccion.programaProduccionCabecera.nroLotes}"
                                                 disabled="#{ManagedProgramaProduccion.programaProduccionCabecera.formulaMaestraVersion.componentesProd.tiposProduccion.codTipoProduccion ne 1}"
                                                 id="nroLotes" styleClass="inputText" onkeypress="valNum(event)">
                                        <f:validator validatorId="validatorDoubleRange"/>
                                        <f:attribute name="minimum" value="1"/>
                                        <f:attribute name="maximum" value="10"/>
                                        <f:attribute name="disable" value="#{(empty param['form1:btnGuardar'])}"/>
                                    </h:inputText>
                                    <h:message for="nroLotes" styleClass="message"/>
                                </h:panelGroup>
                                
                            </h:panelGrid>
                            <a4j:commandLink action="#{ManagedProgramaProduccion.cargarFormulaMaestraAgregar_action}" oncomplete="Richfaces.showModalPanel('panelAgregarFormulaCabecera');"
                                    reRender="form2">
                                <h:graphicImage url="../img/buscar.png" />
                                <h:outputText value="Cambiar Producto"/>
                            </a4j:commandLink>
                        </rich:panel>
                       <rich:dataTable value="#{ManagedProgramaProduccion.programaProduccionAgregarList}" var="data"
                                    id="dataProgramaProduccion" style="width:80%;margin-top:1em"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" rowKeyVar="var"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccion.programaProduccionAgregarDataTable}">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Producto"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Lote"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo Programa Producción"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Presentación"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column>
                                <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{var != 0}" />
                            </rich:column>
                            <rich:column>
                                <a4j:commandLink rendered="#{var != 0}" action="#{ManagedProgramaProduccion.modificarProductoProgramaProduccionAgregar_action}"
                                oncomplete="Richfaces.showModalPanel('panelModificarProducto');" reRender="contenidoModificarProducto">
                                    <h:graphicImage url="../img/edit.jpg" style="vertical-align:middle"/>
                                    <h:outputText styleClass="outputText2" value="#{data.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}"/>
                                </a4j:commandLink>
                                <h:outputText styleClass="outputText2" value="#{data.formulaMaestraVersion.componentesProd.nombreProdSemiterminado}" rendered="#{var eq 0}"/>
                            </rich:column>
                            <rich:column style="text-align:center">
                                <h:inputText value="#{data.cantidadLote}" onkeypress="valNum(event)" onkeyup="sumaCantidadTotalLote()" styleClass="inputText" >
                                    <f:convertNumber pattern="###"/>
                                </h:inputText>
                            </rich:column>
                            <rich:column>
                                <h:selectOneMenu value="#{data.tiposProgramaProduccion.codTipoProgramaProd}" 
                                                 styleClass="inputText" 
                                                 rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd eq ''}">
                                    <f:selectItems value="#{ManagedProgramaProduccion.tiposProgramaProduccionSelectList}" />
                                    <a4j:support event="onchange"  action="#{ManagedProgramaProduccion.cargarPresentacionesProductoSelect}" reRender="contenidoAgregarLote"/>
                                </h:selectOneMenu>
                                <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" rendered="#{data.tiposProgramaProduccion.nombreTipoProgramaProd != ''}"/>
                            </rich:column>
                            <rich:column>
                                <h:selectOneMenu value="#{data.presentacionesProducto.codPresentacion}" styleClass="inputText"
                                                 rendered="#{!data.formulaMaestraVersion.componentesProd.productoSemiterminado}">
                                    <f:selectItems value="#{data.presentacionesProductoList}" />
                                </h:selectOneMenu>
                                <h:outputText value="No Aplica por ser un producto semiterminado"
                                              rendered="#{data.formulaMaestraVersion.componentesProd.productoSemiterminado}"/>
                            </rich:column>
                            <f:facet name="footer">
                                <rich:columnGroup>
                                    <rich:column colspan="2">
                                        <h:outputText value="Cantidad Total" styleClass="outputTextBold"/>
                                    </rich:column>
                                    <rich:column styleClass="tdRight">
                                        <h:outputText value="#{ManagedProgramaProduccion.programaProduccionAgregarListSumaCantidad}" 
                                                      styleClass="outputText2" id="cantidadTotalLote"/>
                                    </rich:column>
                                    <rich:column colspan="2">
                                        <h:outputText value=""/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                        
                        </rich:dataTable>
                    
                     </h:panelGroup>
                     <br/>
                     <center>
                         <a4j:commandLink action="#{ManagedProgramaProduccion.masProgramaProduccionAgregar_action}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/mas.png"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccion.menosProgramaProduccionAgregar_action}" reRender="dataProgramaProduccion" >
                            <h:graphicImage url="../img/menos.png"/>
                        </a4j:commandLink>
                        </center>
                    
                    <br />
                    
                    <a4j:commandButton value="Guardar" onclick="if(!validarRegistro()){return false;}" 
                                       id="btnGuardar" styleClass="btn"  action="#{ManagedProgramaProduccion.guardarAgregarProgramaProduccion_action}"
                                       oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){alert('Se registraron los lotes');window.location.href='navegadorProgramaProduccion.jsf?data='+(new Date()).getTime().toString();}else{alert('#{ManagedProgramaProduccion.mensaje}');}"/>
                    <a4j:commandButton value="Limpiar" styleClass="btn"  action="#{ManagedProgramaProduccion.limpiar_action}" reRender="form1" />
                    <input type="button" class="btn" onclick="window.location.href='navegadorProgramaProduccion.jsf?cancel='+(new Date()).getTime().toString();" value="Cancelar" />
                    

                </div>
                
            </a4j:form>
            <rich:modalPanel id="panelAgregarFormulaCabecera"
                                minHeight="360"  minWidth="700"
                                height="360" width="700" zindex="100"
                                headerClass="headerClassACliente"
                                resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="<center>Seleccionar Producto</center>" escape="false" />
                        </f:facet>
                        <a4j:form id="form2">
                            <center>
                            <h:panelGroup id="contenidoAgregarFormulaCabecera">
                                <h:panelGrid columns="3">
                                    <h:outputText value="Tipo de Produccion" styleClass="outputTextBold"/>
                                    <h:outputText value="::" styleClass="outputTextBold"/>
                                    <h:selectOneRadio value="#{ManagedProgramaProduccion.codTipoProduccion}" styleClass="outputText2">
                                        <f:selectItems value="#{ManagedProgramaProduccion.tiposProduccionSelectList}"/>
                                        <a4j:support event="onchange" action="#{ManagedProgramaProduccion.codTipoProduccionChange()}"
                                                     reRender="detalle"/>
                                    </h:selectOneRadio>
                                </h:panelGrid>
                                <span class="outputTextBold">Producto:</span><input id="productoBuscar" class="inputText" onkeyup="buscarTexto();">
                                <table><tr><td>
                                <div style='height:240px;overflow:auto;width:100%'>
                                <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraVersionAgregarList}"
                                             var="data" id="detalle"
                                             headerClass="headerClassACliente"
                                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                             binding="#{ManagedProgramaProduccion.formulaMaestraVersionAgregarDataTable}">
                                      <f:facet name="header">
                                          <rich:columnGroup>
                                              <rich:column rowspan="2">
                                                  <h:outputText value="Producto Semiterminado"/>
                                              </rich:column>
                                              <rich:column rowspan="2">
                                                  <h:outputText value="Cantidad Lote"/>
                                              </rich:column>
                                              <rich:column colspan="2">
                                                  <h:outputText value="Nro version"/>
                                              </rich:column>
                                              <rich:column breakBefore="true">
                                                  <h:outputText value="Producto"/>
                                              </rich:column>
                                              <rich:column>
                                                  <h:outputText value="E.S."/>
                                              </rich:column>
                                          </rich:columnGroup>
                                      </f:facet>
                                      
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarFormulaMaestraVersionAgregar}"
                                              oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarFormulaCabecera');"
                                              reRender="contenidoAgregarLote">
                                                  <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                              </a4j:commandLink>
                                          </rich:column>
                                          <rich:column styleClass="tdRight #{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.cantidadLote}">
                                                  <f:convertNumber pattern="#,##0" locale="en"/>
                                              </h:outputText>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.componentesProd.nroUltimaVersion}"/>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.componentesProd.nroUltimaVersion}.#{data.formulaMaestraEsVersion.nroVersion}"/>
                                          </rich:column>

                                      
                                </rich:dataTable>
                                </div>
                                </td></tr></table>
                            </h:panelGroup>
                                <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelAgregarFormulaCabecera');" styleClass="btn"
                                               rendered="#{ManagedProgramaProduccion.programaProduccionCabecera.componentesProdVersion.codVersion > 0}"/>
                            <a4j:commandButton value="Volver" styleClass="btn"
                                               onclick="redireccionar('navegadorProgramaProduccion.jsf')"
                                               rendered="#{ManagedProgramaProduccion.programaProduccionCabecera.componentesProdVersion.codVersion eq 0}"/>
                            </center>
                        </a4j:form>
                    </rich:modalPanel>
                    <rich:modalPanel id="panelModificarProducto"
                                     minHeight="340"  minWidth="700"
                                     height="340" width="700" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="<center>Productos para división de lotes</center>" escape="false" />
                        </f:facet>
                        <a4j:form id="form3">
                            <center>
                            <h:panelGroup id="contenidoModificarProducto">
                                <table><tr><td>
                                <div style='height:240px;overflow:auto;width:100%'>
                                <rich:dataTable value="#{ManagedProgramaProduccion.productosDivisionLotesList}"
                                             var="data" id="detalle"
                                             headerClass="headerClassACliente"
                                             onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                             onRowMouseOver="this.style.backgroundColor='#DDE3E4';">
                                      <f:facet name="header">
                                          <rich:columnGroup>
                                              <rich:column rowspan="2">
                                                  <h:outputText value="Producto Semiterminado"/>
                                              </rich:column>
                                              <rich:column rowspan="2">
                                                  <h:outputText value="Tipo Programa Producción"/>
                                              </rich:column>
                                              <rich:column rowspan="2">
                                                  <h:outputText value="Cantidad Lote"/>
                                              </rich:column>
                                              <rich:column colspan="2">
                                                  <h:outputText value="Nro version"/>
                                              </rich:column>
                                              <rich:column breakBefore="true">
                                                  <h:outputText value="Producto"/>
                                              </rich:column>
                                              <rich:column>
                                                  <h:outputText value="F.M."/>
                                              </rich:column>
                                          </rich:columnGroup>
                                      </f:facet>

                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <a4j:commandLink action="#{ManagedProgramaProduccion.seleccionarProductoModificarProductoPrograma_action}"
                                              oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');"
                                              reRender="contenidoAgregarLote">
                                                  <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                                  <f:param name="codTipoProgramaProd" value="#{data.tiposProgramaProduccion.codTipoProgramaProd}"/>
                                                  <f:param name="nombreCompProd" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                                  <f:param name="nombreTipoPrograma" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                                  <f:param name="codFormula" value="#{data.formulaMaestra.codFormulaMaestra}"/>
                                                  <f:param name="codVersionFm" value="#{data.formulaMaestra.codVersionActiva}"/>
                                                  <f:param name="codVersionCp" value="#{data.componentesProd.codVersionActiva}"/>
                                                  <f:param name="codVersionFmEs" value="#{data.formulaMaestraEsVersion.codFormulaMaestraEsVersion}"/>
                                                  <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                              </a4j:commandLink>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.formulaMaestra.cantidadLote}"/>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.componentesProd.nroUltimaVersion}"/>
                                          </rich:column>
                                          <rich:column styleClass="#{data.checked?'seleccionado':''}">
                                              <h:outputText value="#{data.formulaMaestra.nroVersionFormulaActiva}"/>
                                          </rich:column>


                                </rich:dataTable>
                                </div>
                                </td></tr></table>
                            </h:panelGroup>
                            <a4j:commandButton value="Cancelar" oncomplete="javascript:Richfaces.hideModalPanel('panelModificarProducto');" styleClass="btn"/>
                            
                            </center>
                        </a4j:form>
                    </rich:modalPanel>
            <a4j:include viewId="/panelProgreso.jsp"/>
            
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        </body>
    </html>
    
</f:view>

