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
            function calcularCantidadPresentaciones()
            {
               var tamanioLote=parseFloat(document.getElementById("form1:cantidadLote").innerHTML);
               var cantidadPorPresentacion=parseFloat(document.getElementById("form1:cantidad").value);
               var cantidadPresentaciones=tamanioLote/cantidadPorPresentacion;
               document.getElementById("form1:cantidadPresentaciones").innerHTML=(redondear(cantidadPresentaciones,2));
               var celdas=document.getElementById("form1:dataAgregarFormulaMaestraDetalleEp").getElementsByTagName("tbody")[0];
               for(var i=0;i<celdas.rows.length;i++)
               {
                   if(celdas.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                   {
                       celdas.rows[i].cells[2].getElementsByTagName("input")[0].onkeyup();
                   }
                   
               }
           }
           function calcularTotalLote(celda)
           {
               
               var cantidadDecimales=2;
               var tamanioLote=parseFloat(document.getElementById("form1:cantidadLote").innerHTML);
               var cantidadPresentacion=parseFloat(document.getElementById("form1:cantidad").value);
               var cantidadUnitaria=parseFloat(celda.parentNode.parentNode.cells[2].getElementsByTagName("input")[0].value);
               var porcientoExceso=parseFloat(celda.parentNode.parentNode.cells[3].getElementsByTagName("input")[0].value);
               var cantidadTotal=cantidadUnitaria*tamanioLote/(cantidadPresentacion);
               cantidadTotal+=(cantidadTotal*porcientoExceso/100);
               celda.parentNode.parentNode.cells[4].getElementsByTagName("span")[0].innerHTML=
               redondear(cantidadTotal,cantidadDecimales);
               
           }
           function validadRegistroCantidad()
           {
                if(!validarMayorACero(document.getElementById("form1:cantidad")))
                {
                    return false;
                }
               var tabla=document.getElementById("form1:dataAgregarFormulaMaestraDetalleEp");
               var cantidadSeleccionados=0;
               var cantidadMayorCero=0;
               for(var i=1;i<tabla.rows.length;i++)
               {
                   if(tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                   {
                       cantidadSeleccionados++;
                       if(!validarMayorACero(tabla.rows[i].cells[2].getElementsByTagName("input")[0]))
                       {
                           return false;
                       }
                   }
                   if(parseFloat(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value)>0)
                   {
                       cantidadMayorCero++;
                   }
               }
               if((cantidadMayorCero!=cantidadSeleccionados)&&(cantidadSeleccionados>0))
               {
                   return confirm('Existen materiales con cantidad unitaria mayor a cero que no han sido seleccionados para su registro\nDesea guardar de todos modos?');
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
                    <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarAgregarFormulaMaestraDetallaEpAgregar}"/>
                        <rich:panel headerClass="headerClassACliente" style="width:60%;margin-top:0.3em">
                            <f:facet name="header">
                                <h:outputText value="Datos De La Formula"/>
                            </f:facet>
                                <h:panelGrid columns="3">
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                                <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.tamanioLoteProduccion}" styleClass="outputText2" id="cantidadLote" />
                                <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                                
                            </h:panelGrid>
                            
                        </rich:panel>
                        <rich:panel headerClass="headerClassACliente" style="width:60%;margin-top:0.3em">
                            <f:facet name="header">
                                <h:outputText value="Datos De La Presentación"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Tipo Producción" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedVersionesFormulaMaestra.presentacionesPrimariasAgregar.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedVersionesFormulaMaestra.tiposProgramaProduccionSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Envase Primario" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:selectOneMenu value="#{ManagedVersionesFormulaMaestra.presentacionesPrimariasAgregar.envasesPrimarios.codEnvasePrim}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedVersionesFormulaMaestra.envasesPrimariosSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Cantidad Por Presentación" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:inputText styleClass="inputText" id="cantidad" value="#{ManagedVersionesFormulaMaestra.presentacionesPrimariasAgregar.cantidad}" onkeyup="calcularCantidadPresentaciones();" onkeypress="valNum(event)" />
                                <h:outputText value="Cantidad De Presentaciones" styleClass="outputTextBold"/>
                                <h:outputText value="::" styleClass="outputTextBold"/>
                                <h:outputText value="0" styleClass="outputText2" id="cantidadPresentaciones"/>
                            </h:panelGrid>
                        </rich:panel>

                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.presentacionesPrimariasAgregar.formulaMaestraDetalleEPList}"
                                    var="data" id="dataAgregarFormulaMaestraDetalleEp" style="margin-top:0.5em"
                                    headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Material<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>"  escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Unitaria"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Exceso (%)"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad Lote"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad<br>Medida" escape="false"  />
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this);"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.cantidadUnitaria}" size="8" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText" onkeyup="calcularTotalLote(this);"  onkeypress="valNum(event);">
                                <f:convertNumber pattern="###0.0######" locale="en"/>
                            </h:inputText>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{data.porcientoExceso}" size="8" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText" onkeyup="calcularTotalLote(this);"  onkeypress="valNum(event);">
                                <f:convertNumber pattern="###0.0######" locale="en"/>
                            </h:inputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidad}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </rich:column>
                    </rich:dataTable>
                    
                    <div id="bottonesAcccion" class="barraBotones" >
                            <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarFormulaMaestraDetalleEpVersion_action}"
                                    onclick="if(!validadRegistroCantidad()){return false;}"
                                    oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registraron los materiales');var a=Math.random();redireccionar('navegadorFormulaMaestraEP.jsf');}else
                                    {alert('#{ManagedVersionesFormulaMaestra.mensaje}');}" />
                            <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='navegadorVersionFormulaMaestraDetalleEP.jsf?cana='+a;"/>
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

