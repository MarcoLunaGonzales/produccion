
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
       <style type="text/css">
          .a1{
             background-color:rgb;
           }
           .a2{
             background-color:#F0E686;
           }
           .a3
           {
                background-color:#bff9bf;
           }
           .a4
           {
                background-color:#FFB6C1;
           }

       </style>
    <script type="text/javascript" src='../js/general.js' ></script>
     
    <script>
          function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
               }
        </script>
</head>
<body bgcolor="#F2E7F2"  >
<h:form id="form1"  >                
<div align="center">                    
    <br>
    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.cargarProgramaProduccionDevolucionMaterial}" styleClass="outputText2" />
    <b><h:outputText value="DEVOLUCIONES DE MATERIAL AL TERMINAR UN LOTE" styleClass="tituloCabezera1"    /></b>
    <br>
    <br>
          <table id="table1" class="outputText2">
                        <tr>
                            <td class="a2" width="35px"></td>
                            <td>Ingresado Parcialmente</td>
                            <td class="a3" width="35px"></td>
                            <td>Ingresado Totalmente</td>
                            <td class="a4" width="35px"></td>
                            <td>Rechazado</td>
                        </tr>
                    </table>
    <rich:dataTable value="#{ManagedProgramaProducionDevolucionMaterial.programaProduccionDevolucionMaterialList}"
                    var="data"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
                     id="progProdDevMatList" >
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value=""  />
                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{(data.estadoDevolucionMaterial.codEstadoRegistro eq '4' )||(data.estadoDevolucionMaterial.codEstadoRegistro eq '1' )}"/>
                                    </rich:column>
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Producto"  />
                                        </f:facet>
                                        <h:outputText value="#{data.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" />
                                    </rich:column>
                                     <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Registro"  />
                                        </f:facet>
                                        <h:outputText value="#{data.fechaRegistro}" >
                                            <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        </h:outputText>
                                    </rich:column>

                                  <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Lote"  />
                                        </f:facet>
                                        <h:outputText  value="#{data.programaProduccion.codLoteProduccion}"  />
                                    </rich:column>
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Tipo Programa Producción"  />
                                        </f:facet>
                                        <h:outputText value="#{data.programaProduccion.tiposProgramaProduccion.nombreProgramaProd}"  />

                                    </rich:column>
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Area Produción"  />
                                        </f:facet>
                                        <h:outputText value="#{data.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"  >
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad Enviada Acond."  />
                                        </f:facet>
                                        <h:outputText value="#{data.programaProduccion.cantidadLote}"  >
                                        </h:outputText>
                                    </rich:column>
                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                        </f:facet>
                                        <h:outputText value="#{data.estadoDevolucionMaterial.nombreEstadoRegistro} "  >
                                        </h:outputText>
                                    </rich:column>

                                    <rich:column styleClass="a#{data.estadoDevolucionMaterial.codEstadoRegistro}">
                                        <f:facet name="header">
                                            <h:outputText value=""/>
                                        </f:facet>
                                        <a4j:commandLink onclick="openPopup('reporteDetallaProgramaProduccionDevolucionMaterial.jsf?codComprod=#{data.programaProduccion.formulaMaestra.componentesProd.codCompprod}&codTipoProd=#{data.programaProduccion.tiposProgramaProduccion.codTipoProgramaProd}&codLote=#{data.programaProduccion.codLoteProduccion}&codForm=#{data.programaProduccion.formulaMaestra.codFormulaMaestra}&codProg=#{data.programaProduccion.codProgramaProduccion}&nombreProd=#{data.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}&nomTipoProd=#{data.programaProduccion.tiposProgramaProduccion.nombreProgramaProd}&area=#{data.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}&codProgProd=#{data.codProgramaProduccionDevolucionMaterial}')">
                                        <h:graphicImage url="../img/areasdependientes.png">

                                        </h:graphicImage>
                                        </a4j:commandLink>
                                    </rich:column>
        
    </rich:dataTable>
    <a4j:commandButton value="Rehacer" styleClass="btn" action="#{ManagedProgramaProducionDevolucionMaterial.rehacerDevolucionMaterial}" oncomplete="if('#{ManagedProgramaProducionDevolucionMaterial.mensaje}'!=''){alert('#{ManagedProgramaProducionDevolucionMaterial.mensaje}')}else{Richfaces.showModalPanel('panelRehacer')}" reRender="contenidopanelRehacer"/>
    <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedProgramaProducionDevolucionMaterial.editarDevolucionMaterial}" oncomplete="if('#{ManagedProgramaProducionDevolucionMaterial.mensaje}'!=''){alert('#{ManagedProgramaProducionDevolucionMaterial.mensaje}')}else{Richfaces.showModalPanel('panelEditar')}" reRender="contenidopanelEditar"/>

    
    
</div>
<!--cerrando la conexion-->

</h:form>

              <rich:modalPanel id="panelRehacer" minHeight="400"  minWidth="800"
                                     height="400" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Detalle de devolucion "/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidopanelRehacer">
                            <rich:panel style="width:100%"  headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos Programa Producción"  />
                            </f:facet>
                                <h:panelGrid columns="4" >
                                    <h:outputText value="Producto:" styleClass="outputText2"  />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevMaterial.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                    <h:outputText value="Lote:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevMaterial.programaProduccion.codLoteProduccion}" styleClass="outputText2" />
                                    <h:outputText value="Tipo Programa Prod:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevMaterial.programaProduccion.tiposProgramaProduccion.nombreProgramaProd}" styleClass="outputText2" />
                                    <h:outputText value="Area:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevMaterial.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                                    <h:outputText value="Cantidad Enviada Acond." styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevMaterial.programaProduccion.cantidadLote}" styleClass="outputText2" />
                                </h:panelGrid>
                                </rich:panel>

                            <div style="overflow:auto;height:120px;text-align:center">
                                <rich:dataTable value="#{ManagedProgramaProducionDevolucionMaterial.programaProdDevMatListRechazados}"
                                            var="data"
                                            id="programaProdDevMatListEdit"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente" >

                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />
                                                </f:facet>
                                                <h:selectBooleanCheckbox value="#{data.checked}" />
                                            </rich:column>

                                          <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Material"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.materiales.nombreMaterial}"  />
                                            </rich:column>
                                             <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Formula"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.programaProduccionDevolucionMaterial.programaProduccion.formulaMaestra.cantidadLote}"  />
                                            </rich:column>
                                           <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Buenos"/>
                                                </f:facet>
                                                <h:inputText value="#{data.cantidadBuenos}" styleClass="inputText" >
                                                </h:inputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Malos"/>
                                                </f:facet>
                                                <h:inputText value="#{data.cantidadMalos}" styleClass="inputText" >
                                                </h:inputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Unid."  />
                                                </f:facet>
                                                <h:outputText value="#{data.materiales.unidadesMedida.abreviatura}" >
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Observación"/>
                                                </f:facet>
                                                <h:inputText value="#{data.observacion}" styleClass="inputText"  />
                                            </rich:column>


                            </rich:dataTable>
                            </div>



                        </h:panelGroup>
                        <div align="center">
                          <a4j:commandButton styleClass="btn" value="Guardar"
                          action="#{ManagedProgramaProducionDevolucionMaterial.guardarCambioDeDatosRechazados}"
                          onclick="Richfaces.hideModalPanel('panelRehacer')"
                          reRender="progProdDevMatList" />
                          <a4j:commandButton styleClass="btn" value="Cancelar" onclick="Richfaces.hideModalPanel('panelRehacer')" />



                        </div>

                        </a4j:form>

            </rich:modalPanel>

              <rich:modalPanel id="panelEditar" minHeight="400"  minWidth="800"
                                     height="400" width="800"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Detalle de devolucion "/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidopanelEditar">
                            <rich:panel style="width:100%"  headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos Programa Producción"  />
                            </f:facet>
                                <h:panelGrid columns="4" >
                                    <h:outputText value="Producto:" styleClass="outputText2"  />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevEditar.programaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                    <h:outputText value="Lote:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevEditar.programaProduccion.codLoteProduccion}" styleClass="outputText2" />
                                    <h:outputText value="Tipo Programa Prod:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevEditar.programaProduccion.tiposProgramaProduccion.nombreProgramaProd}" styleClass="outputText2" />
                                    <h:outputText value="Area:" styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevEditar.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                                    <h:outputText value="Cantidad Enviada Acond." styleClass="outputText2" />
                                    <h:outputText value="#{ManagedProgramaProducionDevolucionMaterial.currentProgProdDevEditar.programaProduccion.cantidadLote}" styleClass="outputText2" />
                                </h:panelGrid>
                                </rich:panel>
                                <br>
                                <br>
                            <div style="overflow:auto;height:150px;text-align:center">
                                <rich:dataTable value="#{ManagedProgramaProducionDevolucionMaterial.programaProdDevMatListEditar}"
                                            var="data"
                                            id="programaProdDevMatList"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente" >

                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />
                                                </f:facet>
                                                <h:selectBooleanCheckbox value="#{data.checked}" />
                                            </rich:column>

                                          <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Material"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.materiales.nombreMaterial}"  />
                                            </rich:column>
                                             <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Formula"  />
                                                </f:facet>
                                                <h:outputText  value="#{data.programaProduccionDevolucionMaterial.programaProduccion.formulaMaestra.cantidadLote}"  />
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Buenos"/>
                                                </f:facet>
                                                <h:inputText value="#{data.cantidadBuenos}" styleClass="inputText" >
                                                </h:inputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Cantidad Malos"/>
                                                </f:facet>
                                                <h:inputText value="#{data.cantidadMalos}" styleClass="inputText" >
                                                </h:inputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Unid."  />
                                                </f:facet>
                                                <h:outputText value="#{data.materiales.unidadesMedida.abreviatura}" >
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Observación"/>
                                                </f:facet>
                                                <h:inputText value="#{data.observacion}" styleClass="inputText"  />
                                            </rich:column>


                            </rich:dataTable>
                            </div>



                        </h:panelGroup>
                        <div align="center">
                          <a4j:commandButton styleClass="btn" value="Guardar"
                          action="#{ManagedProgramaProducionDevolucionMaterial.guardarCambiosEdicion}"
                          onclick="Richfaces.hideModalPanel('panelEditar')"
                          reRender="progProdDevMatList" />
                         <a4j:commandButton styleClass="btn" value="Cancelar" onclick="Richfaces.hideModalPanel('panelEditar')" />
                         </div>

                        </a4j:form>

            </rich:modalPanel>
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


</body>
</html>

</f:view>


