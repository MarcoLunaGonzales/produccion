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
            <script type="text/javascript" src="../../js/general.js" ></script>
            <script>
                var contPopup=0;
              function verCuestionario(codCuestionario,codDocumento,codPersonal){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='navegadorRevisarCuestionario.jsf?codP='+Math.random()+'&codC='+codCuestionario+'&codDoc='+codDocumento+'&codPersonal='+codPersonal;
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                    // alert(url);
                     window.open(url, ('popUp'+contPopup),opciones);
                    
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarCuestionarioCargos}"/>
                    <h3>Configuracion de Cuestionarios</h3>
                    
                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.cuestionarioCargoList}"
                                    var="data"
                                    id="dataEstadosDocumento"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" style="margin-top:12px;"
                                    >
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre"  />
                            </f:facet>
                            <h:outputText value="#{data.nombrecuestionarioCargo}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Area Empresa"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cargos"  />
                            </f:facet>
                            <h:outputText value="#{data.cargos}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Presentaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.presentaciones}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipos Preguntas"  />
                            </f:facet>
                            <h:outputText value="#{data.tipoPregunta}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
										<h:outputText value="Cant. Preguntas Documento"   />                            </f:facet>
                            <h:outputText value="#{data.nroPreguntasDocumento}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cant. Preguntas Argumentos"   />
                            </f:facet>
                            <h:outputText value="#{data.nroPregutasArgumento}"  />
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Asig. Aleatoria"  />
                            </f:facet>
                            <h:outputText value="#{data.pregAleatorias=='1'?'si':'no'}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tiempo Cuestinario"  />
                            </f:facet>
                            <h:outputText value="#{data.tiempoCuestionario} min"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Prueba"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                            </h:outputText>
                            <h:panelGrid columns="4" styleClass="outputText2">
                                    <h:outputText value="De:"  />
                                    <h:outputText value="#{data.fechaInicio}"  >
                                        <f:convertDateTime pattern="HH:mm"/>
                                    </h:outputText>
                                    <h:outputText value=" a "  />
                                    <h:outputText value="#{data.fechaFinal}">
                                            <f:convertDateTime pattern="HH:mm"/>
                                        </h:outputText>
                                </h:panelGrid>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fecha Alternariva\n Prueba"  />
                                
                            </f:facet>
                            <h:outputText value="#{data.fechaAlternativa}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy" />
                                </h:outputText>
                            <h:panelGrid columns="4" styleClass="outputText2">
                                    <h:outputText value="De:"  />
                                    <h:outputText value="#{data.fechaAlternativaInicio}"  >
                                        <f:convertDateTime pattern="HH:mm"/>
                                    </h:outputText>
                                    <h:outputText value=" a "  />
                                    <h:outputText value="#{data.fechaAlternativaFinal}">
                                            <f:convertDateTime pattern="HH:mm"/>
                                        </h:outputText>
                                </h:panelGrid>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Imprimir"  />
                            </f:facet>
                            <h:commandLink onclick="">
                                <h:graphicImage url="../../img/page_table_warning_32.png"/>
                            </h:commandLink>
                        </h:column>
                         
                        
                    </rich:dataTable>
                    <div style="margin-top:12px;">
                    <a4j:commandButton action="#{ManagedDocumentosBiblioteca.cargarAgregarCuestionarioCargo_action}" reRender="contenidoRegistroCuestionario" value="Agregar" styleClass="btn" oncomplete = "Richfaces.showModalPanel('panelRegistroCuestionarioCargo')" />
                    
                    <a4j:commandButton action="#{ManagedDocumentosBiblioteca.cargarAgregarCuestionarioHermes_action}" reRender="contenidoRegistroCuestionarioHermes" value="Agregar Cuestionario Hermes" styleClass="btn" oncomplete = "Richfaces.showModalPanel('panelRegistroCuestionarioHermes')" />
                   </div>
                   
                </div>
            </a4j:form>

              <rich:modalPanel id="panelRegistroCuestionarioHermes"
                                     minHeight="450"  minWidth="800"
                                     height="450" width="800" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto">
                        <f:facet name="header">
                            <h:outputText value="Registro de Cuestionario Hermes" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form5">
                        <h:panelGroup id="contenidoRegistroCuestionarioHermes">
                            <h:panelGrid columns="6">
                                <h:outputText styleClass="outputText2"   value="Nombre Cuestionario" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:inputText style="width:100%;"  styleClass="inputText" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.nombrecuestionarioCargo}" />
                                <h:outputText styleClass="outputText2"   value="Preguntas Aleatoria" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:selectBooleanCheckbox value="#{ManagedDocumentosBiblioteca.pregAleatorias}"  />
                                <h:outputText styleClass="outputText2"   value="Producto" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:selectManyListbox value="#{ManagedDocumentosBiblioteca.codPresentacionProd}" style="width:250px;" styleClass="inputText" size="4">
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.presentacionesSelectList}"/>
                                </h:selectManyListbox>
                                 <h:outputText styleClass="outputText2"   value="Area Empresa" style="font-weight:bold;"  />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:selectManyListbox value="#{ManagedDocumentosBiblioteca.areasEmpresaHermes}" styleClass="outputText2"  style="width:250px;" size="4">
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.areasEmpresaRegionalesList}" />
                                </h:selectManyListbox>
                                <h:outputText styleClass="outputText2"   value="Tipos de Preguntas" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:selectManyListbox value="#{ManagedDocumentosBiblioteca.codTiposPreguntas}" styleClass="outputText2" size="4"  >
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntaList}" />
                                </h:selectManyListbox>
                                <h:outputText styleClass="outputText2"   value="Cargo" style="font-weight:bold;"  />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:selectManyListbox value="#{ManagedDocumentosBiblioteca.codCargosHermes}" styleClass="outputText2" id="codCargo"  size="2">
                                    <f:selectItems value="#{ManagedDocumentosBiblioteca.cargosList}"   />
                                </h:selectManyListbox>
                                <h:outputText styleClass="outputText2"   value="Nro Preguntas Documentacion" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.nroPreguntasDocumento}" />
                                <h:outputText styleClass="outputText2"   value="Nro Preguntas Argumentos" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.nroPregutasArgumento}" />
                                <h:outputText styleClass="outputText2"   value="Tiempo Cuestionario" style="font-weight:bold;" />
                                <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.tiempoCuestionario}" />
                            </h:panelGrid>
                            <h:panelGrid columns="2">
                            <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="Fecha Prueba"/>
                                </f:facet>
                                <h:panelGrid columns="6">
                                        <h:outputText styleClass="outputText2"   value="Fecha" style="font-weight:bold;"  />
                                        <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                        <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaRegistro}" size="10">
                                            <f:convertDateTime  pattern="dd/MM/yyyy" />
                                        </h:inputText>
                                        <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;"  />
                                        <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;" />
                                        <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;" />
                                        <h:outputText styleClass="outputText2"   value="Hora inicio" style="font-weight:bold;"  />
                                        <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                        <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaInicio}" size="5">
                                            <f:convertDateTime  pattern="HH:mm" />
                                        </h:inputText>
                                            
                                        <h:outputText styleClass="outputText2"   value="Hora Final" style="font-weight:bold;"  />
                                        <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                        <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaFinal}" size="5">
                                            <f:convertDateTime  pattern="HH:mm" />
                                        </h:inputText>
                                    </h:panelGrid>
                                </rich:panel>
                                <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="Fecha Alternativa de Prueba"/>
                                </f:facet>
                                <h:panelGrid columns="6">
                                    <h:outputText styleClass="outputText2"   value="Fecha" style="font-weight:bold;"  />
                                    <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                    <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaAlternativa}" size="10">
                                        <f:convertDateTime  pattern="dd/MM/yyyy" />
                                    </h:inputText>
                                    <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;"  />
                                        <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;" />
                                        <h:outputText styleClass="outputText2"   value="" style="font-weight:bold;" />
                                    <h:outputText styleClass="outputText2"   value="Hora inicio" style="font-weight:bold;"  />
                                    <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                    <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaAlternativaInicio}"size="5">
                                        <f:convertDateTime  pattern="HH:mm" />
                                    </h:inputText>
                                    <h:outputText styleClass="outputText2"   value="Hora Final" style="font-weight:bold;"  />
                                    <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                                    <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaAlternativaFinal}" size="5">
                                        <f:convertDateTime  pattern="HH:mm" />
                                    </h:inputText>
                                    </h:panelGrid>
                                </rich:panel>
                                </h:panelGrid>
                        </h:panelGroup>
                        <br/>

                        <a4j:commandButton  value="Guardar" styleClass="btn"
                        action="#{ManagedDocumentosBiblioteca.guardarCuestionarioCargoHermes_action}" reRender="dataEstadosDocumento"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje!='1'}){alert('#{ManagedDocumentosBiblioteca.mensaje}')};javascript:Richfaces.hideModalPanel('panelRegistroCuestionarioHermes')" />


                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelRegistroCuestionarioHermes')" />

                        </div>
                        </a4j:form>
              </rich:modalPanel>



               <%--rich:modalPanel id="panelRegistroCuestionarioCargo"
                                     minHeight="550"  minWidth="700"
                                     height="550" width="700" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Registro de Cuestionario" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoRegistroCuestionario">

                            <h:panelGrid columns="6">

                            <h:outputText styleClass="outputText2"   value="Nombre Cuestionario" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:inputText style="width:100%;"  styleClass="inputText" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.nombrecuestionarioCargo}" />
                            <h:outputText styleClass="outputText2"   value="Preguntas Aleatoria" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectBooleanCheckbox value="#{ManagedDocumentosBiblioteca.pregAleatorias}"  >
                                <a4j:support event="onclick"  action="#{ManagedDocumentosBiblioteca.onchangeTiposPreguntasDoc}" reRender="dataPreguntasSelect"/>
                            </h:selectBooleanCheckbox>
                            <h:outputText styleClass="outputText2"   value="Producto" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.componentesProd.codCompprod}" styleClass="inputText">
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.componenteProdList}"/>
                                <a4j:support event="onchange"  action="#{ManagedDocumentosBiblioteca.onchangeTiposPreguntasDoc}" reRender="dataPreguntasSelect"/>
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputText2"   value="Maquinaria" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.maquinaria.codMaquina}" styleClass="inputText">
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.maquinariaList}"/>
                                <a4j:support event="onchange"  action="#{ManagedDocumentosBiblioteca.onchangeTiposPreguntasDoc}" reRender="dataPreguntasSelect"/>
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputText2"   value="Nro Preguntas" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.nroPreguntas}" />
                            
                            <h:outputText styleClass="outputText2"   value="Tipos de Preguntas" style="font-weight:bold;" />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectManyListbox value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.tiposDocumentacionPreguntasList}" styleClass="outputText2" size="4"  >
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.tiposDocumentacionPreguntaList}" />
                                <a4j:support event="onchange"  action="#{ManagedDocumentosBiblioteca.onchangeTiposPreguntasDoc}" reRender="dataPreguntasSelect"/>
                            </h:selectManyListbox>
                            <h:outputText styleClass="outputText2"   value="Area Empresa" style="font-weight:bold;"  />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.areasEmpresa.codAreaEmpresa}" styleClass="outputText2"  style="width:250px;" >
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.areaEmpresaList}" />
                                <a4j:support action="#{ManagedDocumentosBiblioteca.areaChange_action}" event="onchange" reRender="codCargo" />
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputText2"   value="Cargo" style="font-weight:bold;"  />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.cargos.codigoCargo}" styleClass="outputText2" id="codCargo" >
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.cargosList}"   />
                            </h:selectOneMenu>
                            <h:outputText styleClass="outputText2"   value="Fecha" style="font-weight:bold;"  />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaRegistro}" >
                                <f:convertDateTime  pattern="dd/MM/yyyy" />
                            </h:inputText>
                            <h:outputText styleClass="outputText2"   value="Hora inicio" style="font-weight:bold;"  />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaInicio}" >
                                <f:convertDateTime  pattern="HH:mm" />
                            </h:inputText>
                            <h:outputText styleClass="outputText2"   value="Hora Final" style="font-weight:bold;"  />
                            <h:outputText styleClass="outputText2"   value="::" style="font-weight:bold;" />
                            <h:inputText styleClass="inputText1" value="#{ManagedDocumentosBiblioteca.cuestionarioPersonalCargo.fechaFinal}" >
                                <f:convertDateTime  pattern="HH:mm" />
                            </h:inputText>
                            </h:panelGrid>
                            <div style="height:150px;overflow-y:auto">
                                    <rich:dataTable value="#{ManagedDocumentosBiblioteca.documentacionPreguntasListSelect}"
                                            var="data"
                                            id="dataPreguntasSelect"
                                            onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                            onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                            headerClass="headerClassACliente" style="margin-top:12px;" rendered="#{!ManagedDocumentosBiblioteca.pregAleatorias}"
                                            >
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value=""  />
                                                </f:facet>
                                                <h:selectBooleanCheckbox  value="#{data.checked}"  />
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Documento"/>
                                                </f:facet>
                                                <h:outputText value="#{data.documentacion.nombreDocumento}"  />
                                            </h:column>
                                            <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Tipo Pregunta"  />
                                                </f:facet>
                                                <h:outputText value="#{data.tiposDocumentacionPreguntas.nombreTipoDocumentacionPregunta}"/>
                                            </h:column>
                                             <h:column>
                                                <f:facet name="header">
                                                    <h:outputText value="Descripcion Pregunta"  />
                                                </f:facet>
                                                <h:outputText value="#{data.descripcionPregunta}"  />
                                            </h:column>
                                    </rich:dataTable>
                            </div>
                        </h:panelGroup>
                        <br/>

                        <a4j:commandButton  value="Guardar" styleClass="btn"
                        action="#{ManagedDocumentosBiblioteca.guardarCuestionarioCargo}" reRender="dataEstadosDocumento"
                        oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje!=''}){alert('#{ManagedDocumentosBiblioteca.mensaje}')};javascript:Richfaces.hideModalPanel('panelRegistroCuestionarioCargo')" />


                        <input type="button" value="Cancelar" class="btn" onclick="javascript:Richfaces.hideModalPanel('panelRegistroCuestionarioCargo')" />

                        </div>
                        </a4j:form>
                  </rich:modalPanel--%>
                
            

        </body>
    </html>

</f:view>

