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
            
           function validadRegistroCantidad()
           {
               var tabla=document.getElementById("form1:dataMp");
               for(var i=1;i<tabla.rows.length;i++)
               {
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
           
            function checkCantidadPorFraccion(input)
            {
                var celda=input.parentNode;
                celda.getElementsByTagName("input")[1].style.display=(input.checked?"initial":"none");
            }
                                       </script>
            <style>
                .activo
                {
                    background-color:#90EE90;
                }
            </style>
        </head>
        <body >
            <h:form id="form1"  >
                <div align="center" >
                   
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
                    <rich:dataTable value="#{ManagedProductosDesarrolloVersion.formulaMaestraDetalleMPEditarList}"
                                var="data" id="dataMp" style="margin-top:0.5em"
                                headerClass="headerClassACliente" rowKeyVar="cont">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column>
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
                                <rich:column>
                                    <h:outputText value="Tipo<br>Material" escape="false"/>
                                </rich:column>
                            </rich:columnGroup>
                        </f:facet>

                        <rich:column>
                            <h:outputText value="#{cont+1}"/>
                        </rich:column>
                        
                        <rich:column  >
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
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </rich:column>
                        <rich:column styleClass="tdCenter">
                            <h:selectBooleanCheckbox value="#{data.aplicaCantidadMaximaPorFraccion}" onclick="checkCantidadPorFraccion(this)"/>
                            <h:inputText styleClass="inputText #{data.aplicaCantidadMaximaPorFraccion?'':'displayNone'}" value="#{data.cantidadMaximaMaterialPorFraccion}" onkeyup="valNum(this)" onblur="valorPorDefecto(this)"
                                         size="10"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposMaterialProduccion.nombreTipoMaterialProduccion}"/>
                        </rich:column>
                         
                    </rich:dataTable>
                    <div id="bottonesAcccion" class="barraBotones" >
                        <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedProductosDesarrolloVersion.editarFormulaMaestraDetalleMpAction}"
                                            onclick="if(!validadRegistroCantidad()){return false;}"
                                            oncomplete="if(#{ManagedProductosDesarrolloVersion.mensaje eq '1'}){var a=Math.random();alert('Se registraron los materiales');window.location.href='navegadorFormulaMaestraVersionMP.jsf?agre='+a}else{alert('#{ManagedProductosDesarrolloVersion.mensaje}');}"/>
                        <a4j:commandButton  value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='navegadorFormulaMaestraVersionMP.jsf?canA='+a"/>
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

