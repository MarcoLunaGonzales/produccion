<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
             <script src="../../js/general.js"></script>
            <script>
            var CANTIDAD_COLUMNAS_ES_DEFINE_LOTE = 5;
            function validadRegistroCantidad()
            {
                if(!validarMayorACero(document.getElementById("form1:cantidadProducto")))
                {
                    return false;
                }
                var tabla=document.getElementById("form1:dataMaterialES").getElementsByTagName("tbody")[0];
                var cantidadSeleccionados=0;
                var cantidadSelecionadosEs = 0;
                var cantidadMayorCero=0;
                var validarSeleccionEs = (tabla.rows.length > 0 && tabla.rows[0].cells.length == CANTIDAD_COLUMNAS_ES_DEFINE_LOTE);
                for(var i = 0 ; i < tabla.rows.length ; i ++)
                {
                    if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                    {
                       cantidadSeleccionados++;
                       if(validarSeleccionEs)
                           cantidadSelecionadosEs += (tabla.rows[i].cells[4].getElementsByTagName("input")[0].checked ? 1 : 0);
                       if(!validarMayorACero(tabla.rows[i].cells[2].getElementsByTagName("input")[0]))
                           return false;
                    }
                    if(parseFloat(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value)>0)
                    {
                       cantidadMayorCero++;
                    }
               }
               if(validarSeleccionEs && cantidadSelecionadosEs !=1){
                   alert('Para la forma farmaceutica debe registrar un item que defina el numero de lote');
                   return false;
               }
               if((cantidadMayorCero!=cantidadSeleccionados)&&(cantidadSeleccionados>0))
               {
                   return confirm('Existen materiales con cantidad mayor a cero que no han sido seleccionados para su registro\nDesea guardar de todos modos?');
               }
               if(cantidadSeleccionados==0)
               {
                   alert('No se encontraron materiales para el registro');
                   return false;
               }
               return true;
           }
           function seleccionarRegistro(checked)
           {
                checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
           }
           onerror=function()
           {
               alert('Ocurrio un error de ejecuci�n del sistema,por favor notifique a sistemas');
           };
           
           </script>
        </head>
        <body >
            <h:form id="form1"  >
                <span class="outputTextTituloSistema">Edici�n de Presentaci�n y Material de Empaque Secundario</span>
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraEsVersion.cargarEditarComponentesPresProdVersion_action}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos Del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tama�o Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tamanioLoteProduccion}" styleClass="outputText2" />
                        </h:panelGrid>
                        <rich:panel headerClass="headerClassACliente" style="min-width:50%;max-width:90%" id="datosPresentacion">
                            <f:facet name="header">
                                <h:outputText value="Datos Presentacion Secundaria"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Presentaci�n Producto" styleClass="outputTextBold" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputTextBold" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionEditar.presentacionesProducto.nombreProductoPresentacion}" styleClass="outputText2"/>
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionEditar.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2"/>
                                <h:outputText value="Cantidad" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionEditar.cantCompProd}" styleClass="inputText" onblur="valorPorDefecto(this)" id="cantidadProducto"/>
                                <h:outputText value="Estado" styleClass="outputTextBold" />
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionEditar.estadoReferencial.codEstadoRegistro}" styleClass="inputText">
                                    <f:selectItem itemValue="1" itemLabel="Activo"/>
                                    <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                </h:selectOneMenu>
                                
                            </h:panelGrid>
                        </rich:panel>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionEditar.formulaMaestraDetalleESList}"  
                                    var="data" id="dataMaterialES" style="margin-top:0.5em"
                                    headerClass="headerClassACliente">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Empaque Secundario<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'"  escape="false"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad"/>
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Unidad Medida"  />
                                    </rich:column>
                                    <rich:column rendered="#{ManagedFormulaMaestraEsVersion.defineLoteEs}">
                                        <h:outputText value="Seleccione el material<br/>que define el<br/>n�mero de lote" escape="false"/>
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:columnGroup style="background-color:#{data.checked?'#90EE90':'#ffffff'}">
                                <rich:column>
                                    <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2" />
                                </rich:column>
                                <rich:column style="">
                                    <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText"  onkeypress="valNum(event);"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                                </rich:column>
                                <rich:column rendered="#{ManagedFormulaMaestraEsVersion.defineLoteEs}">
                                    <center>
                                        <h:selectBooleanCheckbox value="#{data.defineNumeroLote}"/>
                                    </center>
                                </rich:column>
                            </rich:columnGroup>
                        
                        
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestraEsVersion.guardarEdicionComponentesPresProdVersion_action}"
                        onclick="if(!validadRegistroCantidad()){return false;}" oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se registro la edici�n la presentacion y materiales de empaque secundario para el producto');
                        window.location.href='navegadorFormulaMaestraDetalleEsVersion.jsf?agre='+(new Date()).getTime().toString();}else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}" />
                        <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorFormulaMaestraDetalleEsVersion.jsf?cancel='+(new Date()).getTime().toString();"/>
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
        </body>
    </html>
    
</f:view>
