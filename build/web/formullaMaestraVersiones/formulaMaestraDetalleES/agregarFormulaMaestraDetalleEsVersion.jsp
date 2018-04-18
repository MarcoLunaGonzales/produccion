<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../../css/chosen.css" />
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
           onerror=function()
           {
               alert('Ocurrio un error de ejecución del sistema,por favor notifique a sistemas');
           };
           
           </script>
        </head>
        <body >
            <h:form id="form1"  >
                
                
                
                <div align="center">
                    <span class="outputTextTituloSistema">Registro de Presentación y Material de Empaque Secundario</span>
                    <h:outputText value="#{ManagedFormulaMaestraEsVersion.cargarAgregarMaterialesEsVersion}"/>
                    <rich:panel headerClass="headerClassACliente" style="width:70%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos Del Producto"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputTextBold" />
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputTextBold"/>
                            <h:outputText value="::" styleClass="outputTextBold" />
                            <h:outputText value="#{ManagedFormulaMaestraEsVersion.componentesProdVersionBean.tamanioLoteProduccion}" styleClass="outputText2" />
                        </h:panelGrid>
                        <rich:panel headerClass="headerClassACliente" style="min-width:50%;max-width:95%" id="datosPresentacion">
                            <f:facet name="header">
                                <h:outputText value="Datos Presentacion Secundaria"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Presentación Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionAgregar.presentacionesProducto.codPresentacion}" styleClass="inputText chosen">
                                    <f:selectItems value="#{ManagedFormulaMaestraEsVersion.presentacionesSelectList}"/>
                                    <a4j:support event="onchange" action="#{ManagedFormulaMaestraEsVersion.codPresentacionAgregar_change}" reRender="datosPresentacion"/>
                                </h:selectOneMenu>
                                <h:outputText value="Tipo Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:selectOneMenu value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionAgregar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" id="codTipoProduccion">
                                    <f:selectItems value="#{ManagedFormulaMaestraEsVersion.tiposProgramaProduccionSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Cantidad" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionAgregar.cantCompProd}" styleClass="inputText" onblur="valorPorDefecto(this)" id="cantidadProducto"/>
                                
                            </h:panelGrid>
                        </rich:panel>
                    </rich:panel>
                        <rich:dataTable value="#{ManagedFormulaMaestraEsVersion.componentesPresProdVersionAgregar.formulaMaestraDetalleESList}"  
                                    var="data" id="dataMaterialES" style="margin-top:0.5em"
                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Empaque Secundario<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'"  escape="false"/>
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" styleClass="outputText2" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"   />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText"  onkeypress="valNum(event);"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </h:column>
                        <h:column rendered="#{ManagedFormulaMaestraEsVersion.defineLoteEs}">
                            <f:facet name="header">
                                <h:outputText value="Seleccione el material<br/> que define el<br/> número de lote" escape="false"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.defineNumeroLote}"/>
                        </h:column>
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestraEsVersion.guardarAgregarComponentesPresProdVersion_action}"
                        onclick="if(!validadRegistroCantidad()){return false;}"
                        oncomplete="if(#{ManagedFormulaMaestraEsVersion.mensaje eq '1'}){alert('Se registro la presentación y materiales para el producto');
                        window.location.href='navegadorFormulaMaestraDetalleEsVersion.jsf?agre='+(new Date()).getTime().toString();}
                        else{alert('#{ManagedFormulaMaestraEsVersion.mensaje}');}" />
                        <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="window.location.href='navegadorFormulaMaestraDetalleEsVersion.jsf?cancel='+(new Date()).getTime().toString();"/>
                    </div>
                    
                    
                </div>
                
                
            </h:form>
            <a4j:include viewId="/panelProgreso.jsp"/>
        </body>
    </html>
    
</f:view>

