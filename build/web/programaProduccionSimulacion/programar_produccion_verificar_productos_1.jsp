package programaProduccionSimulacion;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>

<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script LANGUAGE="JavaScript">
                function verificaNumero(evt) {
                    evt = (evt) ? evt : window.event
                    var charCode = (evt.which) ? evt.which : evt.keyCode

                    if ((charCode > 31 && (charCode < 48 || charCode > 57))) {
                        if(charCode==46){
                            return true;
                        }
                        return false;
                    }
                    return true;
                    //[0-9]+(\.[0-9][0-9]?)?

                }
                function getfocus(valor)
                {
                    var valores=document.getElementsByName(valor);
                    valores[0].focus();

                    valores[0].value = valores[0].value;
                }

function cambiarCantidadItem(nametable,fila){                    
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //iteracion de los elementos de la tabla
                   // this.parentNode.parentNode.getElementsByTagName('td')[2].innerHTML;
                   var producto = fila.getElementsByTagName('td')[2].innerHTML;
                   var tipoMercaderia = fila.getElementsByTagName('td')[4].innerHTML;
                   
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var productoItera = cellsElement[2];
                    var tipoMercaderiaItera =cellsElement[4];

                    if( producto == productoItera.innerHTML && tipoMercaderia == tipoMercaderiaItera.innerHTML){
                        cellsElement[3].getElementsByTagName('input')[0].value=fila.getElementsByTagName('td')[3].firstChild.value ;
                        
                    }
                   }
                   
   return true;
}
function closePanelMateriales(){
                    document.getElementById('form:panelMateriales').style.visibility='hidden';                    
 }
            </script>
        </head>

        <body>
            <div  align="center" id="panelCenter">
                PRODUCTOS PARA PRODUCCION
                <a4j:form id="form">
                    <h:outputText value="#{ManagedProgramaProduccionVerificarProducto.cargarContenidoVerificarProductos}" />
                    <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.programaProduccionList}" 
                                    var="fila" id="programaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.programaProduccionDataTable}"
                                    >

                        <!--document.getElementById('form:panelMateriales').style.visibility='visible';-->

                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="" />
                            </f:facet>
                            
                            <h:selectBooleanCheckbox value="#{fila.checked}" >
                                            <a4j:support action="#{ManagedProgramaProduccionVerificarProducto.seleccionarMaterial_action}"
                                            reRender="programaProduccion" event="onclick" />
                            </h:selectBooleanCheckbox>
                        </rich:column>
                        <rich:column style="background-color: #{fila.colorFila}" >
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <h:outputText value=""  />
                        </rich:column>
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Producto" />
                            </f:facet>
                            <h:outputText value="#{fila.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>

                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad" />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadLote}"   />
                        </rich:column>                        

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{fila.codLoteProduccion}"  />
                        </rich:column>

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Tipo"  />
                            </f:facet>
                            <h:outputText value="#{fila.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column>

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{fila.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column>

                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <a4j:commandLink value="Detalle" action="#{ManagedProgramaProduccionVerificarProducto.verProgramaProduccionDetalle_action}"
                            reRender="contenidoProgramaProduccionDetalle" onclick="Richfaces.showModalPanel('panelProgramaProduccionDetalle')" />
                            
                        </rich:column>

                      

                    </rich:dataTable>




                    
                    <br>
                    <%-- COMPONENTES CON MATERIALES: --%>
                    <br>
                    <rich:dataTable  value="#{ManagedProgramaProduccionVerificarProducto.componentesConMaterialesList}"
                                         width="50%"  var="fila"
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         headerClass="headerClassACliente"
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                         id="componentesConMateriales" rows="7" align="center"
                                         binding="#{ManagedProgramaProduccionVerificarProducto.componentesConMaterialesDataTable}" >
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Producto"/>
                                </f:facet>
                                <h:outputText value="#{fila.nombreCompProd} "/>
                            </rich:column>
                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                             <h:outputText value="#{fila.cantLoteProduccion}"/>
                        </rich:column>
                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoProgramaProd}"  />
                        </rich:column>

                     </rich:dataTable>
                     <%--rich:datascroller align="center" for="componentesConMateriales" maxPages="20" id="scComponentesConMateriales" ajaxSingle="true" reRender="panelComponentes" /--%>
                    <br>
                    <%-- COMPONENTES CON MATERIAL FALTANTE --%>
                    <br>
                    <h:panelGroup id="panelComponentes">
                    <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.componentesList}" var="fila" id="componentes"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.componentesDataTable}"
                                    rows="40"
                                    >

                        <rich:column style="#{fila.estiloEstado}">
                            <f:facet name="header">
                                <h:outputText value="Seleccionar"  />
                            </f:facet>
                            <h:selectBooleanCheckbox  id="chck" value="#{fila.seleccionadoCheck}" rendered="#{fila.conCheck}">
                                <a4j:support  oncomplete="if(#{ManagedProgramaProduccionVerificarProducto.mensajes !=''}){javascript:Richfaces.showModalPanel('panelMateriales',{width:100, top:100});}" reRender="panelComponentes,componentes,materialesFaltantes,mensajes,nombreComponenteSeleccionado" ajaxSingle="false"  event="onclick" onsubmit="this.blur()"  actionListener="#{ManagedProgramaProduccionVerificarProducto.seleccionaComponente_action}"/>
                                <%--<a4j:support  oncomplete="if(#{ManagedProgramaProduccionVerificarProducto.mensajes !=''}){alert('#{ManagedProgramaProduccionVerificarProducto.mensajes}');}" reRender="componentes" ajaxSingle="false"  event="onclick" onsubmit="this.blur()"  actionListener="#{ManagedProgramaProduccionVerificarProducto.seleccionaComponente_action}" />--%>
                            </h:selectBooleanCheckbox>
                        </rich:column>
                        
                        <!--document.getElementById('form:panelMateriales').style.visibility='visible';-->
                        
                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Material" />
                            </f:facet>
                            <h:outputText value="#{fila.nombreMaterial}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Producto" />
                            </f:facet>
                            <h:outputText value="#{fila.nombreCompProd}"   />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:inputText value="#{fila.cantLoteProduccion}"   size="6" styleClass="inputText" rendered="#{fila.conInputTextCantLoteProduccion}" readonly="#{fila.inputTextCantLoteProduccionSoloLectura}" onkeyup="cambiarCantidadItem('form:componentes',this.parentNode.parentNode);" >
                                <%--<a4j:support event="onkeydown" reRender="componentes" ajaxSingle="false" />--%>
                                <%--<a4j:support event="onblur" reRender="componentes" ajaxSingle="false" actionListener="#{ManagedProgramaProduccionVerificarProducto.cambiaCantLoteProduccionComponente_action}"/>--%>
                            </h:inputText>
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{fila.nombreTipoProgramaProd}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Prioridad"  />
                            </f:facet>
                            <h:outputText value="#{fila.categoria}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="A Utilizar"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadAUtilizar}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Disponible"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadDisponible}" />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="En Transito"  />
                            </f:facet>
                            <h:outputText value="#{fila.cantidadEnTransito}"  />
                        </rich:column>

                        <rich:column style="#{fila.estiloEstado}" >
                            <f:facet name="header">
                                <h:outputText value="Stock Minimo"  />
                            </f:facet>
                            <h:outputText value="#{fila.stockMinimoMaterial}"  />
                        </rich:column>

                    </rich:dataTable>
                    
                    <rich:datascroller align="center" for="componentes" maxPages="20" id="sc2" ajaxSingle="true" reRender="panelComponentes" />
                    </h:panelGroup>
                    

                    <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>
                    
                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">
                                     
                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>

                    <%--rich:modalPanel id="panelMateriales" minHeight="400"
                                     minWidth="600" height="400" width="600" zindex="100" headerClass="headerClassACliente">
                        <f:facet name="header">
                            <h:outputText value="Materiales" />
                        </f:facet>
                        <div align="center">

                        COMPONENTE SELECCIONADO : 
                        <h:outputText value="#{ManagedProgramaProduccionVerificarProducto.seleccionadoComponente.nombreCompProd}" id="nombreComponenteSeleccionado" />
                        <rich:dataTable  value="#{ManagedProgramaProduccionVerificarProducto.materialesFaltantesList}"
                                         width="100%"  var="fila" 
                                         onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                         headerClass="headerClassACliente"
                                         onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                                         id="materialesFaltantes" rows="7" align="center">
                            <rich:column >
                                <f:facet name="header">
                                    <h:outputText value="Material"/>
                                </f:facet>
                                <h:outputText value="#{fila.nombreMaterial} "/>
                            </rich:column>                            
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="A Utilizar"  />
                                </f:facet>                                
                                <h:outputText value="#{fila.cantidadAUtilizar} "  />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Disponible"  />
                                </f:facet>
                                <h:outputText value="#{fila.cantidadDisponible} "  />
                            </rich:column>
                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="En Transito"  />
                                </f:facet>
                                <h:outputText value="#{fila.cantidadEnTransito} "  />
                            </rich:column>                            
                        </rich:dataTable>
                        <rich:datascroller align="center" for="materialesFaltantes" maxPages="20" id="scMatFaltantes" ajaxSingle="true" />
                        <br>
                        <h:outputText value="#{ManagedProgramaProduccionVerificarProducto.mensajes}" id="mensajes" />
                        <br>
                            <a4j:commandButton  value="Aprobar bajo Riesgo" styleClass="boton" onclick="javascript:Richfaces.hideModalPanel('panelMateriales')" reRender="panelComponentes,componentes"  action="#{ManagedProgramaProduccionVerificarProducto.aprobarBajoRiesgo_action}"  ajaxSingle="false" status="statusPeticion"/>
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelMateriales')" />
                        </div>
                    </rich:modalPanel--%>
                    
                    <h:commandButton value="Aceptar" action="#{ManagedProgramaProduccionVerificarProducto.verificarParaAprobarProgramaProduccion}"  />
                    <h:commandButton value="Cancelar" action="#{ManagedProgramaProduccionVerificarProducto.cancelarProgramarProduccion_action}"  />

                </div>

            </a4j:form>



             <rich:modalPanel id="panelProgramaProduccionDetalle" minHeight="400"  minWidth="800"
                                     height="400" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Programa Produccion Detalle"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoProgramaProduccionDetalle">
                            <div align="center">
                            <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.programaProduccionDetalleList}"
                                    var="fila" id="programaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionVerificarProducto.programaProduccionDetalleDataTable}"
                                    >

                                    <!--document.getElementById('form:panelMateriales').style.visibility='visible';-->

                                    <rich:column >
                                        <f:facet name="header">
                                            <h:outputText value="" />
                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{fila.checked}" >
                                            
                                        </h:selectBooleanCheckbox>
                                    </rich:column>
                                    
                                    <rich:column style="background-color: #{fila.colorFila}" >
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <h:outputText value=""  />
                                    </rich:column>

                                    <rich:column >
                                        <f:facet name="header">
                                            <h:outputText value="Material" />
                                        </f:facet>
                                        <h:outputText value="#{fila.materiales.nombreMaterial}"  />
                                    </rich:column>

                                    <rich:column >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad" />
                                        </f:facet>
                                        <h:outputText value="#{fila.cantidad}"    >
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us" />
                                        </h:outputText>
                                    </rich:column>                        

                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Unidades"  />
                                        </f:facet>
                                        <h:outputText value="#{fila.unidadesMedida.nombreUnidadMedida}"  />
                                    </rich:column>

                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad Disponible"  />
                                        </f:facet>
                                        <h:outputText value="#{fila.cantidadDisponible}"  >
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us"  />
                                        </h:outputText>
                                    </rich:column>

                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad Transito"  />
                                        </f:facet>
                                        <h:outputText value="#{fila.cantidadTransito}"  >                                            
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us"  />
                                        </h:outputText>
                                    </rich:column>


                                </rich:dataTable>



                                
                                <a4j:commandButton styleClass="btn" value="Registrar"
                                onclick="javascript:Richfaces.hideModalPanel('panelProgramaProduccionDetalle');"
                                action="#{ManagedFrecuenciaMantenimientoMaquinaria.registrarFrecuenciaMantenimientoMaquina_action}"
                                reRender="dataFrecuenciaMantenimientoMaquina"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelProgramaProduccionDetalle')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>




        </body>
    </html>

</f:view>

