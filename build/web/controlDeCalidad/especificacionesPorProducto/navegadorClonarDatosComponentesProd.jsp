<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src='../../js/general.js' ></script>
            <script type="text/javascript" src='../../js/treeComponet.js' ></script>
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
            <script type="text/javascript">
                function verificarResultadoRegistro(resultado)
                {
                    if(resultado =='1')
                    {
                        if(confirm('Se duplicaron las especificaciones en el producto destino\nDesea ver el reporte de especificaciones del producto destino?'))
                            {
                                window.open("../../reportes/reporteEspecificacionesAreaProducto/reporteEspecificacionesAreaProducto.jsf?codArea=80,81,82,95"+
                                    "&nombreArea=LIQUIDOS NO ESTERILES,LIQUIDOS ESTERILES,SEMISOLIDOS,SOLIDOS NO ESTERILES &codProd="+document.getElementById("form1:codComprodDestino").value+"&aled="+Math.random(),'DETALLE'+Math.round(Math.random()*1000),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                            }
                    }
                    else
                    {
                        alert(resultado);
                    }
                }
                function validarRegistro()
                {
                    var clonacionPermitida=false;
                    if(document.getElementById("form1:dataEspecificacionesFisicas").rows.length>2)
                        {
                            clonacionPermitida=true;
                        }
                    if(document.getElementById("form1:dataEspecificacionesQuimicas").rows.length>2)
                    {
                        clonacionPermitida=true;
                    }
                    if(document.getElementById("form1:dataEspecificacionesMicro").rows.length>2)
                    {
                        clonacionPermitida=true;
                    }
                    if(!clonacionPermitida)
                    {
                        alert('No hay datos disponibles para duplicar');
                        return false;
                    }
                    else{
                        return confirm('Esta seguro de registrar las especificaciones para el producto destino?\nSe borraran especificaciones anteriores');
                    }

                }
            </script>
        </head>
        <body>
            
            <h:form id="form1"  >                
                
                    
                    <h:outputText value="#{ManagedEspecificacionesControlCalidad.cargarNavegadorClonarEspecificacionesProducto}"   />
                    <center><h3>Duplicar Especificaciones de Control de Calidad</h3>   </center>
                   
                    <div align="center">
                        <rich:panel headerClass="headerClassACliente" style="width:60%">
                            <f:facet name="header">
                                <h:outputText style="font-weight:bold" value="BUSCADOR"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                        <%--h:outputText value="Forma Farmaceutica" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdFormaClonar.forma.codForma}" id="codForma"   >
                                        <f:selectItems value="#{ManagedEspecificacionesControlCalidad.formasFarmaceuticasSelectList}"  />
                                        <a4j:support event="onchange" action="#{ManagedEspecificacionesControlCalidad.formaFarmaceutica_change}" reRender="codCompProdBuscar,codComprodDestino"/>
                                        </h:selectOneMenu--%>

                                        <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdFormaClonar.codCompprod}" id="codCompProdBuscar"  >
                                            <f:selectItems value="#{ManagedEspecificacionesControlCalidad.componentesProdSelectList}"  />
                                        </h:selectOneMenu>
                                        <h:outputText value="Producto Destino" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu styleClass="inputText" value="#{ManagedEspecificacionesControlCalidad.componentesProdClonarDestino.codCompprod}" id="codComprodDestino"  ><%--onchange="submit();" valueChangeListener="#{ManagedEspecificacionesControlCalidad.filtrarEstadosCompProd}"  --%>
                                        <f:selectItems value="#{ManagedEspecificacionesControlCalidad.componentesProdSelectList}"  />
                                        </h:selectOneMenu>
                                </h:panelGrid>
                                <a4j:commandButton value="Buscar" action="#{ManagedEspecificacionesControlCalidad.buscarEspecificacionesControlCalidad_action}" styleClass="btn" reRender="dataEspecificaciones"/>
                       </rich:panel>
                       <h:panelGroup id="dataEspecificaciones" >
                        <rich:dataTable value="#{ManagedEspecificacionesControlCalidad.listaEspecificacionesFisicasProductoClonar}" var="data" id="dataEspecificacionesFisicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" style="margin-top:12px;"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column colspan="6" >
                                        <h:outputText style="font-weight:bold;" value="Especificaciones Fisicas"  />
                                </rich:column>
                                <rich:column breakBefore="true">
                                     <h:outputText value=""  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Analisis Fisico"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Especificaciones"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Referencia"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Tipo Especificacion Fisica"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Estado"  />
                                </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                         <rich:column>
                            
                            <h:selectBooleanCheckbox value="#{data.checked}"  />

                        </rich:column >
                        <rich:column>
                            <h:outputText value="#{data.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column>
                            <center><h:inputText value="#{data.descripcion}" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/></center>
                            <h:panelGrid columns="3" rendered="#{data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}" >
                                <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            <h:outputText value="-" styleClass="outputText2"/>
                            <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            </h:panelGrid>
                            <h:panelGrid columns="2" rendered="#{(data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2')&&(data.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')}">
                            <h:outputText value="#{data.especificacionFisicaCC.coeficiente} #{data.especificacionFisicaCC.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                            <h:inputText value="#{data.valorExacto}"  onkeypress="valNumero()" size="5" styleClass="inputText"/>
                            </h:panelGrid>
                        </rich:column >
                         <rich:column>
                             <h:selectOneMenu value="#{data.especificacionFisicaCC.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedEspecificacionesControlCalidad.listaTiposReferenciaCc}"/>
                             </h:selectOneMenu>
                        </rich:column >
                        <rich:column>
                             <h:selectOneMenu value="#{data.tiposEspecificacionesFisicas.codTipoEspecificacionFisica}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedEspecificacionesControlCalidad.tiposEspecificacionesFisicas}"/>
                             </h:selectOneMenu>
                        </rich:column >
                         <rich:column>
                             <h:selectOneMenu value="#{data.estado.codEstadoRegistro}" styleClass="inputText">
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="No Activo"/>
                             </h:selectOneMenu>
                        </rich:column >



                   </rich:dataTable>


                   <rich:dataTable style="margin-top:12px;" value="#{ManagedEspecificacionesControlCalidad.listaEspecificacionesQuimicasProductoClonar}" var="data" id="dataEspecificacionesQuimicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Especificaciones Quimicas" style="font-weight:bold" />

                            </f:facet>
                            <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="#{data.nombreEspecificacion}"/>
                                </f:facet>
                              <center>  <rich:dataTable value="#{data.listaEspecificacionesQuimicasProducto}" var="data1" id="dataEspecificacionesProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                                        <%--rich:column rendered="#{data1.estado.codEstadoRegistro eq '1'}"--%>
                                        <rich:column>
                                         <f:facet name="header">
                                            <h:outputText value="Material"  />
                                            </f:facet>
                                            <h:outputText value="#{data1.material.nombreMaterial}" rendered="#{data1.materialesCompuestosCc.codMaterialCompuestoCc eq '0'}"  />
                                            <h:outputText value="#{data1.materialesCompuestosCc.nombreMaterialCompuestoCc}" rendered="#{data1.materialesCompuestosCc.codMaterialCompuestoCc>0}"  />

                                     </rich:column >
                                     <rich:column >
                                        <f:facet name="header">
                                          <h:outputText value="Especificaciones"  />
                                         </f:facet>
                                        <h:inputText value="#{data1.descripcion}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText"/>
                                        <h:panelGrid columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                            <h:inputText value="#{data1.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                         <h:outputText value="-" />
                                         <h:inputText value="#{data1.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                        </h:panelGrid>
                                        <h:panelGrid columns="2" rendered="#{(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2') &&(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')}">
                                            <h:outputText value="#{data.coeficiente} #{data.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                         <h:inputText value="#{data1.valorExacto}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                                        </h:panelGrid>
                                    </rich:column >
                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="referencia"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                                <f:selectItems value="#{ManagedEspecificacionesControlCalidad.listaTiposReferenciaCc}"/>
                                            </h:selectOneMenu>
                                     </rich:column >

                                     <rich:column >
                                         <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:selectOneMenu value="#{data1.estado.codEstadoRegistro}" styleClass="inputText">
                                                <f:selectItem itemValue="1" itemLabel="Activo"/>
                                                <f:selectItem itemValue="2" itemLabel="No Activo"/>
                                            </h:selectOneMenu>
                                     </rich:column>

                                </rich:dataTable>
                                </center>
                            </rich:panel>

                        </rich:column >




                   </rich:dataTable>



                   <rich:dataTable style="margin-top:12px" value="#{ManagedEspecificacionesControlCalidad.listaEspecificacionesMicrobiologiaProductoClonar}" var="data" id="dataEspecificacionesMicro"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="5">
                                    <h:outputText style="font-weight:bold;" value="Especificaciones Microbiologicas"  />
                                </rich:column>
                                <rich:column breakBefore="true">
                                     <h:outputText value=""  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Analisis Microbiologico"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Especificaciones"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Referencia"  />
                                </rich:column>
                                <rich:column>
                                     <h:outputText value="Estado"  />
                                </rich:column>
                                

                            </rich:columnGroup>
                        </f:facet>
                         <rich:column>
                            
                            <h:selectBooleanCheckbox value="#{data.checked}"  />

                        </rich:column >
                        <rich:column>
                            <h:outputText value="#{data.especificacionMicrobiologiaCc.nombreEspecificacion}"  />
                        </rich:column >
                        <rich:column>
                            <h:inputText value="#{data.descripcion}" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}"  styleClass="inputText"/>
                            <h:panelGrid columns="3" rendered="#{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                <h:inputText value="#{data.limiteInferior}" size="5" onkeypress="valNumero()" styleClass="inputText" />
                            <h:outputText value="-" />
                            <h:inputText value="#{data.limiteSuperior}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            </h:panelGrid>
                            <h:panelGrid columns="2" rendered="#{(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')&&(data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')}">

                            <h:outputText value="#{data.especificacionMicrobiologiaCc.coeficiente} #{data.especificacionMicrobiologiaCc.tipoResultadoAnalisis.simbolo}" styleClass="outputText2"/>
                            <h:inputText value="#{data.valorExacto}" size="5" onkeypress="valNumero()" styleClass="inputText"/>
                            </h:panelGrid>
                        </rich:column >
                         <rich:column>
                             <h:selectOneMenu value="#{data.especificacionMicrobiologiaCc.tiposReferenciaCc.codReferenciaCc}" styleClass="inputText">
                                 <f:selectItems value="#{ManagedEspecificacionesControlCalidad.listaTiposReferenciaCc}"/>
                             </h:selectOneMenu>
                        </rich:column >
                         <rich:column>
                             <h:selectOneMenu value="#{data.estado.codEstadoRegistro}">
                                 <f:selectItem itemValue="1" itemLabel="Activo"/>
                                 <f:selectItem itemValue="2" itemLabel="No Activo"/>
                             </h:selectOneMenu>
                        </rich:column >


                   </rich:dataTable>
                   </h:panelGroup>
                    <br>
                    
                    
                </div>
                <div style="text-align:center">
                    <a4j:commandButton styleClass="btn" action="#{ManagedEspecificacionesControlCalidad.clonarEspecificacionesProductoDestino}" value="Guardar"
                    onclick="if(!validarRegistro()){return false;}"
                    oncomplete="verificarResultadoRegistro('#{ManagedEspecificacionesControlCalidad.mensaje}')"
                    />
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

