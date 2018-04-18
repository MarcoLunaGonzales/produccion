<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
            <script src="../../../js/general.js"></script>
            <script>
            
           function validarNoNegativos()
           {
               var tabla=document.getElementById("form1:dataMp");
               
               for(var i=1;i<tabla.rows.length;i++)
                   {

                       if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].type=="checkbox")
                       {

                          if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked==true)
                              {

                                //alert(tabla.rows[i].cells[2].getElementsByTagName('input')[0].value);
                                    if(!(parseFloat(tabla.rows[i].cells[2].getElementsByTagName('input')[0].value)>0))
                                        {

                                            alert('No puede registrar una cantidad menor o igual a cero en el material '+tabla.rows[i].cells[1].getElementsByTagName('span')[0].innerHTML);
                                            tabla.rows[i].cells[2].focus();
                                            return false;
                                        }
                                    if(!(parseInt(tabla.rows[i].cells[4].getElementsByTagName('input')[0].value)>0))
                                        {

                                            alert('No puede registrar una cantidad de fracciones menor o igual a cero en el material '+tabla.rows[i].cells[1].getElementsByTagName('span')[0].innerHTML);
                                            tabla.rows[i].cells[4].focus();
                                            return false;
                                        }
                              }


                       }
                   }
             return true;
           }
           function seleccionarRegistro(checked)
           {
                checked.parentNode.parentNode.style.backgroundColor=(checked.checked?'#90EE90':'');
           }
           function calcularTotalLote(celda)
           {
               var fila=celda.parentNode.parentNode;
               var volumen=(document.getElementById("form1:cantidadVolumen")!==null?parseFloat(document.getElementById("form1:cantidadVolumen").innerHTML):0);
               var volumenDosificado=(document.getElementById("form1:cantidadVolumenDosificado")!==null?parseFloat(document.getElementById("form1:cantidadVolumenDosificado").innerHTML):0);
               var toleranciaFabricacion=parseFloat(document.getElementById("form1:toleranciaFabricacion").innerHTML);
               var tamanioLote=parseFloat(document.getElementById("form1:cantidadLote").innerHTML);
               var codTipoMedida=parseInt(fila.cells[5].getElementsByTagName("input")[0].value);
               var equivalenciaG=parseFloat(fila.cells[5].getElementsByTagName("input")[1].value);
               var equivalenciaMl=parseFloat(fila.cells[5].getElementsByTagName("input")[2].value);
               var cantidadUnitaria=parseFloat(fila.cells[2].getElementsByTagName("input")[0].value);
               var densidad=1;
               var incrementoVolumen=(volumen>0&&volumenDosificado>0?(volumenDosificado/volumen):1);
               var cantidadTotalGramos=((cantidadUnitaria*incrementoVolumen*tamanioLote)+((cantidadUnitaria*incrementoVolumen*tamanioLote)*(toleranciaFabricacion/100)));
               fila.cells[3].getElementsByTagName("span")[0].innerHTML=redondeoHalfUp(cantidadTotalGramos,2);
               var cantidadTotalLote=0;
               if(codTipoMedida!=2)
               {
                   densidad=1/parseFloat(fila.cells[4].getElementsByTagName("input")[0].value);
                   console.log(densidad);
                   cantidadTotalLote=cantidadTotalGramos*(1/equivalenciaMl)*densidad;
               }
               else
               {
                   cantidadTotalLote=cantidadTotalGramos*(1/equivalenciaG);
               }
               fila.cells[5].getElementsByTagName("span")[0].innerHTML=redondear(cantidadTotalLote,2);
           }
           onerror=function()
           {
               alert('Ocurrio un error de validación favor notifique a sistemas');
           };
           function validadRegistroCantidad()
           {
               var tabla=document.getElementById("form1:dataMp").getElementsByTagName("tbody")[0];
               var cantidadSeleccionados=0;
               var cantidadMayorCero=0;
               for(var i=0;i<tabla.rows.length;i++)
               {
                   if(tabla.rows[i].cells[0].getElementsByTagName("input").length>0&&tabla.rows[i].cells[0].getElementsByTagName("input")[0].checked)
                   {
                       cantidadSeleccionados++;
                       if(!(validarMayorACero(tabla.rows[i].cells[2].getElementsByTagName("input")[0])&&
                            validarMayorACero(tabla.rows[i].cells[4].getElementsByTagName("input")[0])))
                       {
                           return false;
                       }
                       if(tabla.rows[i].cells[7].getElementsByTagName("input")[0].checked)
                       {
                            if(!validarMayorACero(tabla.rows[i].cells[7].getElementsByTagName("input")[1]))
                            {
                                return false;
                            }
                       }
                       
                   }
                   if(parseFloat(tabla.rows[i].cells[2].getElementsByTagName("input")[0].value)>0)
                   {
                       cantidadMayorCero++;
                   }
               }
               if((cantidadMayorCero!==cantidadSeleccionados)&&(cantidadSeleccionados>0))
               {
                   return confirm('Existen materiales con cantidad unitaria mayor a cero que no han sido seleccionados para su registro\nDesea guardar de todos modos?');
               }
               if(cantidadSeleccionados===0)
               {
                   alert('No se encontraron materiales para el registro');
                   return false;
               }
               return true;
           }
            function checkCantidadPorFraccion(input)
            {
                var celda=input.parentNode;
                celda.getElementsByTagName("input")[1].style.display=(input.checked?"initial":"none");
            }
        </script>
            
        </head>
        <body onload="Richfaces.showModalPanel('panelSeleccionarTipoMaterialProduccion')">
            <h:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDesarrolloVersion.cargarAgregarFormulaMaestraDetalleMP}" />
                    <rich:panel headerClass="headerClassACliente" style="width:60%;margin-top:0.3em">
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
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.tamanioLoteProduccion}" styleClass="outputText2" id="cantidadLote" />
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                            <h:outputText value="Volumen teórico" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80' || ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.cantidadVolumen}" styleClass="outputText2"  id="cantidadVolumen" />
                            <h:outputText value=" #{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Volumen de dosificado" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.cantidadVolumenDeDosificado}"  styleClass="outputText2" id="cantidadVolumenDosificado" />
                            <h:outputText value=" #{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Tolerancia Fabricación" styleClass="outputText2" style="font-weight:bold" />
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                            <h:panelGroup >
                                <h:outputText value="#{ManagedProductosDesarrolloVersion.formulaMaestraVersionSeleccionado.componentesProd.toleranciaVolumenfabricar}"  styleClass="outputText2" id="toleranciaFabricacion" />
                            <h:outputText value=" %" styleClass="outputText2" />
                            </h:panelGroup>
                        </h:panelGrid>
                    </rich:panel>
                    <h:outputText value="Material para #{ManagedProductosDesarrolloVersion.tiposMaterialProduccionSeleccionado.nombreTipoMaterialProduccion}"
                                  styleClass="outputTextBold" id="tipoMaterialProduccion"/>        
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPAgregarList}"
                                var="data" id="dataMp" style="margin-top:0.5em"
                                headerClass="headerClassACliente">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column >
                                    <h:outputText value=""/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Materia Prima<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'>"  escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad<br>Unitaria<br>Gramos" escape="false"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad<br>Total<br>Gramos" escape="false"  />
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Densidad<br>Material<br>(g/ml)" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Cantidad<br>Material<br>Almacen" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Unidad<br>Medida<br>Almacen" escape="false"/>
                                </rich:column>
                                <rich:column>
                                    <h:outputText value="Dividir Cantidad<br>Por Fracción<br>Gramos" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>

                        <rich:column>
                            <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{(data.unidadesMedida.tipoMedida.codTipoMedida eq '2' &&data.equivalenciaAGramos>0)||(data.unidadesMedida.tipoMedida.codTipoMedida eq '1' &&data.equivalenciaAMiliLitros>0)}" onclick="seleccionarRegistro(this);"  />
                        </rich:column>
                        <rich:column>
                            <h:outputText  value="#{data.materiales.nombreMaterial}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column >
                            <h:inputText value="#{data.cantidadUnitariaGramos}" size="10" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText" onkeyup="calcularTotalLote(this);"  onkeypress="valNum(event);">
                                <f:convertNumber pattern="###0.0######" locale="en"/>
                            </h:inputText>
                        </rich:column>
                        <rich:column >
                            <h:outputText value="#{data.cantidadTotalGramos}" styleClass="outputText2">
                                <f:convertNumber pattern="###0.0#" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column >
                            <h:inputText value="#{data.densidadMaterial}" rendered="#{data.unidadesMedida.tipoMedida.codTipoMedida!=2}" size="10" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText" onkeyup="calcularTotalLote(this);"  onkeypress="valNum(event);">
                                <f:convertNumber pattern="###0.0######" locale="en"/>
                            </h:inputText>
                        </rich:column>
                        <rich:column >
                            <h:inputHidden value="#{data.unidadesMedida.tipoMedida.codTipoMedida}"/>
                            <h:inputHidden value="#{data.equivalenciaAGramos}"/>
                            <h:inputHidden value="#{data.equivalenciaAMiliLitros}"/>
                            <h:outputText value="#{data.cantidad}" styleClass="outputText2">
                                <f:convertNumber pattern="###0.0#" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}" />
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <h:selectBooleanCheckbox value="#{data.aplicaCantidadMaximaPorFraccion}" onclick="checkCantidadPorFraccion(this)"/>
                            <h:inputText styleClass="inputText #{data.aplicaCantidadMaximaPorFraccion?'':'displayNone'}" value="#{data.cantidadMaximaMaterialPorFraccion}" onkeyup="valNum(this)" onblur="valorPorDefecto(this)"
                                         size="10"/>
                        </rich:column>
                        
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedProductosDesarrolloVersion.guardarFormulaMaestraDetalleMpAction}"
                                            onclick="if(!validadRegistroCantidad()){return false;}"
                                            oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){alert('Se registraron los materiales');redireccionar('navegadorFormulaMaestraVersionMP.jsf')}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}');}"/>
                        <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="redireccionar('navegadorFormulaMaestraVersionMP.jsf')"/>
                    </div>
               </div>
            </h:form>
            <rich:modalPanel id="panelSeleccionarTipoMaterialProduccion"  minHeight="170"  minWidth="450"
                            height="200" width="450"
                            zindex="50"
                            headerClass="headerClassACliente"
                            resizeable="false" style="overflow :auto" >
               <f:facet name="header">
                   <h:outputText value="<center>Seleccionar tipo de material</center>" escape="false"/>
               </f:facet>
               <a4j:form>
               <h:panelGroup id="contenidoSeleccionarTipoMaterialProduccion">
                   <div align="center">
                       <rich:dataTable value="#{ManagedProductosDesarrolloVersion.tiposMaterialProduccionList}"
                                       var="tipoMaterial">
                           <rich:column>
                               <a4j:commandLink value="#{tipoMaterial.nombreTipoMaterialProduccion}"
                                                action="#{ManagedProductosDesarrolloVersion.cargarAgregarFormulaMaestraDetalleMPAction}"
                                                reRender="dataMp,tipoMaterialProduccion"
                                                oncomplete="Richfaces.hideModalPanel('panelSeleccionarTipoMaterialProduccion')">
                                   <f:setPropertyActionListener value="#{tipoMaterial}" target="#{ManagedProductosDesarrolloVersion.tiposMaterialProduccionSeleccionado}"/>
                               </a4j:commandLink>
                           </rich:column>
                           
                       </rich:dataTable>
                    </div>
               </h:panelGroup>
               <br/>
               <div align="center">
                    <a4j:commandButton value="Cancelar" oncomplete="Richfaces.hideModalPanel('panelSeleccionarTipoMaterialProduccion')"
                                      rendered="#{ManagedProductosDesarrolloVersion.tiposMaterialProduccionSeleccionado.codTipoMaterialProduccion > 0}"
                                      styleClass="btn"/>
                    <a4j:commandButton value="Volver" oncomplete="redireccionar('navegadorFormulaMaestraVersionMP.jsf')"
                                      rendered="#{ManagedProductosDesarrolloVersion.tiposMaterialProduccionSeleccionado.codTipoMaterialProduccion eq 0}"
                                      styleClass="btn"/>
               </div>
               </a4j:form>
           </rich:modalPanel>
            <a4j:include viewId="/panelProgreso.jsp" />
        </body>
    </html>
    
</f:view>

