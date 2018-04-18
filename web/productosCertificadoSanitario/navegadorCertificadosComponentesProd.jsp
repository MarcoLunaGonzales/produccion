

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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                .proximoVencimiento{
                    background-color:#FFFF00;
                }
                .vencido{
                    background-color:#FF6347;
                }
                .registrado
                {
                    background-color:#90EE90;
                }
            </style>
            <script>
                 var cod=1;
                 function openPopup(url1){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     cod++;
                    window.open(url,('popUp'+cod),opciones)
                    
                }
               
                 function openPopup2(url1){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'&codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     cod++;
                    window.open(url,('popUp'+cod),opciones)

                 }
                 function verRegistro(codProd)
                {
                    
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codComprod="+codProd+"&a="+Math.random();
                }
                
                function ocultaRegistro()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
                function refrescar()
                {
                    ok();
                }
                   A4J.AJAX.onError = function(req,status,message){
                    window.alert("Ocurrio un error: "+message);
                    }
                    A4J.AJAX.onExpired = function(loc,expiredMsg){
                    if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                    return loc;
                    } else {
                    return false;
                    }
                    }
                    onerror=showErrorConsole;
                    function showErrorConsole()
                    {
                        console.log('error de javascript');
                    }
            </script>
        </head>
        <body>
            
            <h:form id="form1"  >
                <h:outputText value="#{ManagedCertificadosSanitarios.cargarCertificadosComponentesProd}"/>
                <a4j:jsFunction name="ok" id="ok" timeout="9000"
                action="#{ManagedCertificadosSanitarios.buscarComponentesProd_action}" reRender="dataCertificadosSanitarios"/>
                <div align="center">                    
                   <rich:panel headerClass="headerClassACliente" style="width:80%;align:center">
                                    <f:facet name="header">
                                            <h:outputText value="Certificados de Registro Sanitario"/>
                                    </f:facet>
                                    <h:panelGrid columns="6">
                                        <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.componentesProdBean.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.areasEmpresasSelectList}"/>
                                        </h:selectOneMenu>
                                        
                                        <h:outputText value="Forma Farmaceúticas" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.componentesProdBean.forma.codForma}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.formasFarmaceuticasSelectList}"/>
                                        </h:selectOneMenu>
                                         <h:outputText value="Estado Producto:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.componentesProdBean.estadoCompProd.codEstadoCompProd}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.estadosComponentesProdSelectList}"/>
                                        </h:selectOneMenu>
                                        <h:outputText value="Nombre Producto:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedCertificadosSanitarios.componentesProdBean.nombreProdSemiterminado}" styleClass="inputText" style="width:100%"/>
                                        <h:outputText value="Nombre Genérico:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedCertificadosSanitarios.componentesProdBean.nombreGenerico}" styleClass="inputText" style="width:100%"/>
                                        <h:outputText value="Registro Sanitario:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedCertificadosSanitarios.componentesProdBean.regSanitario}" styleClass="inputText" style="width:100%"/>
                                        <h:outputText value="De fecha vencimiento:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                         <h:panelGroup>
                                             <h:inputText value="#{ManagedCertificadosSanitarios.fechaInicioBuscador}"   styleClass="inputText"  id="fechaInicio"  size="15"  >
                                                 <f:convertDateTime pattern="dd/MM/yyyy"   />
                                        </h:inputText>
                                        <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha2" />
                                        <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaInicio' click_element_id='form1:imagenFecha2'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                        <h:outputText value="A fecha vencimiento:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:panelGroup>
                                            <h:inputText value="#{ManagedCertificadosSanitarios.fechaFinalBuscador}"   styleClass="inputText"  id="fechaFinal"  size="15" >
                                                         <f:convertDateTime pattern="dd/MM/yyyy"   />
                                                </h:inputText>
                                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha3" />
                                                <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaFinal' click_element_id='form1:imagenFecha3'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                        <h:outputText value="Ordenar fecha:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.ordenarFecha}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.ordenarSelectList}"/>
                                        </h:selectOneMenu>
                                        <h:outputText value="Tipos Archivos:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.tiposArchivos}" styleClass="inputText">
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.tiposArchivosSelectList}"/>
                                        </h:selectOneMenu>
                                    </h:panelGrid>
                                    <center><a4j:commandButton value="BUSCAR" action="#{ManagedCertificadosSanitarios.buscarComponentesProd_action}" styleClass="btn"
                                    reRender="dataCertificadosSanitarios"/></center>
                    </rich:panel>
                    <table style="margin-top:12px">
                        <tr>
                            <td><h:outputText styleClass="outputText2" value="Registrados" style="font-weight:bold"/> </td><td class="registrado" style="width:50px"></td>
                            <td><h:outputText styleClass="outputText2" value="Proximos a Vencer(1 mes)" style="font-weight:bold"/> </td><td class="proximoVencimiento" style="width:50px"></td>
                            <td><h:outputText styleClass="outputText2" value="Vencidos" style="font-weight:bold"/> </td><td class="vencido" style="width:50px"></td>
                        </tr>
                    </table>
                    <rich:dataTable value="#{ManagedCertificadosSanitarios.componentesProdList}" var="data" id="dataCertificadosSanitarios"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="margin-top:12px"
                                    >
                        
                      
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Producto Semiterminado"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProdSemiterminado}"  />
                        </rich:column >  
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Estado Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoCompProd.nombreEstadoCompProd}"  />
                        </rich:column >
                        
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Forma Farmacéutica"  />
                            </f:facet>
                            <h:outputText value="#{data.forma.nombreForma}"  />
                        </rich:column >
                       
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Área de Fabricación"  />
                            </f:facet>
                            <h:outputText value="#{data.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Generico"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreGenerico}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Reg. Sanitario"  />
                            </f:facet>
                            <h:outputText value="#{data.regSanitario}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Vencimiento R.S."  />
                            </f:facet>
                            <h:outputText value="#{data.fechaVencimientoRS}"   styleClass="outputtText2">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                               </h:outputText>
                        </rich:column >
                          <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Subir Registro Certificado Sanitario"  />
                            </f:facet>
                            <a4j:commandLink oncomplete="verRegistro('#{data.codCompprod}');Richfaces.showModalPanel('modalPanelSubirArchivo');">
                                <h:graphicImage url="../img/detalle.jpg"/>
                            </a4j:commandLink>
                        </rich:column >
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Ver Certificado Sanitario"  />
                            </f:facet>
                            <a4j:commandLink  oncomplete="openPopup('certificadosPdf/#{data.direccionArchivoSanitario}?')" title="Ver Certificado Sanitario" rendered="#{data.direccionArchivoSanitario !=''}">
                                <h:graphicImage url="../img/pdf.jpg"/>
                            </a4j:commandLink>
                        </rich:column >
                        
                        
                    </rich:dataTable>
                    
                    
                    
                </div>
               
            </h:form>
            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="350" headerClass="headerClassACliente"
                                     minWidth="450" height="350" width="650" zindex="100" >
            <f:facet name="header">
                <h:outputText value="Subir Certificado Sanitario"/>
            </f:facet>
                <div align="center"  >
                    <iframe src="" id="frameSubir" width="100%" height="100%" align="center"></iframe>
                </div>

            </rich:modalPanel>
            <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
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

