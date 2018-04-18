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
                    <rich:panel id="panelTransacciones" styleClass="panelBuscar" >
                        <f:facet name="header">
                            <h:outputText value="Por favor cambie la fecha" />
                        </f:facet>
                        <a4j:commandButton value="Aceptar" id="botonT" reRender="fechaComprobante,codAreaEmpresa,fechaOculta" styleClass="commandButton"   actionListener="#{ManagedRegistroComprobantesCajaChica.transaccionIncorrecta}" onclick="document.getElementById('form1:panelTransacciones').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';" />

                      </rich:panel>
                    <div style="height:350px;overflow:auto;width:70%;">
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
                                    <h:outputText value="Nro Lotes"  />
                                </f:facet>
                                <h:outputText value="#{fila.nroLotes}"  />
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

                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Materiales"  />
                                </f:facet>
                                <a4j:commandLink value="Detalle" action="#{ManagedProgramaProduccionVerificarProducto.verProgramaProduccionDetalle_action}"
                                reRender="contenidoProgramaProduccionDetalle" onclick="Richfaces.showModalPanel('panelProgramaProduccionDetalle')" />

                            </rich:column>

                            <rich:column>
                                <f:facet name="header">
                                    <h:outputText value="Horas HH/MM"  />
                                </f:facet>
                                <a4j:commandLink value="Detalle" action="#{ManagedProgramaProduccionVerificarProducto.verHorasHombreMaquina_action}"
                                reRender="contenidoHorasHombreMaquina" onclick="Richfaces.showModalPanel('panelHorasHombreMaquina')" />

                            </rich:column>
                        </rich:dataTable>
                    </div>
                    <br/>

                    
                    <h:commandButton value="Aceptar" action="#{ManagedProgramaProduccionVerificarProducto.aprobarProgramaProduccion_action2}" styleClass="btn"  />
                    <h:commandButton value="Cancelar" action="#{ManagedProgramaProduccionVerificarProducto.cancelarProgramarProduccion_action}"  styleClass="btn" />

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

            <rich:modalPanel id="panelHorasHombreMaquina" minHeight="400"  minWidth="800"
                                     height="400" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Detalle de Horas"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoHorasHombreMaquina">
                            <div align="center">
                            <rich:dataTable value="#{ManagedProgramaProduccionVerificarProducto.horasHombreMaquinaList}"
                                    var="fila" id="horasHombreMaquina"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    >
                                    <!--document.getElementById('form:panelMateriales').style.visibility='visible';-->
                                    <%--rich:column >
                                        <f:facet name="header">
                                            <h:outputText value="" />
                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{fila.checked}">
                                            
                                        </h:selectBooleanCheckbox>
                                    </rich:column--%>

                                    <rich:column style="background-color: #{fila.colorFila}" >
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <h:outputText value=""  />
                                    </rich:column>
                                    

                                    <rich:column >
                                        <f:facet name="header">
                                            <h:outputText value="HH" />
                                        </f:facet>
                                        <h:outputText value="#{fila.maquinaria.nombreMaquina}"  />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="HH" />
                                        </f:facet>
                                        <h:outputText value="#{fila.horasHombre}"  />
                                    </rich:column>
                                    

                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="HM" />
                                        </f:facet>
                                        <h:outputText value="#{fila.horasMaquina}"    >
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us" />
                                        </h:outputText>
                                    </rich:column>


                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="HH Disponible" />
                                        </f:facet>
                                        <h:outputText value="#{fila.horasHDisponible}"  >
                                            <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us" />
                                            
                                        </h:outputText>

                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="HM Disponible" >
                                                <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="###.00" locale="us" />
                                            </h:outputText>
                                        </f:facet>
                                        <h:outputText value="#{fila.horasMDisponible}"  />
                                    </rich:column>
                                </rich:dataTable>



                                
                                <a4j:commandButton styleClass="btn" value="Registrar"
                                onclick="javascript:Richfaces.hideModalPanel('panelHorasHombreMaquina');"
                                action="#{ManagedFrecuenciaMantenimientoMaquinaria.registrarFrecuenciaMantenimientoMaquina_action}"
                                reRender="dataFrecuenciaMantenimientoMaquina"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelHorasHombreMaquina')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>





        </body>
    </html>

</f:view>

