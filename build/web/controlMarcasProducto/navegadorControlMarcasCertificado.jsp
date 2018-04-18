<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

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
                    background-color:#f7f7aa;
                }
                .vencido{
                   background-color:#FFA07A;
                }
                .registrado
                {
                    /*background-color:#98FB98;*/
                }
            </style>
            <script>
                 function openPopup(url1){

                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'codP='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                    window.open(url, 'popUp',opciones)
                    
                }


                 function openPopup2(url){
                    
                    var a=Math.random();
                    var name="registro touch"+Math.random();
                    window.open(url+'&a='+a,name,'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                 function openPopup2(url1){
                    
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url=url1+'&codPr='+Math.random();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     var nombrePopup='popUp';
                    window.open(url,nombrePopup ,opciones);

                }
                function verRegistro(codMarca)
                {
                    var a=new Date();
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codMarcaProducto="+codMarca+"&a="+Math.random()+"&date="+(a.getTime.toString());
                }
                function ocultaRegistro()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
                function refrescar()
                {
                    ok();
                }
                var contPopup=0;
                function verCopiaControlada(url1){
                    //alert(url1);
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='../MostrarCopiaControladaMarca?srce='+url1+'&date='+(new Date()).getTime().toString();
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                    window.open(url, ('popUp'+contPopup),opciones);
                    


                }

            </script>
        </head>
        <body>
           
            <h:form id="form1"  >
                <h:outputText value="#{ManagedCertificadosSanitarios.cargarProductosControlMarcas}"/>
                <div align="center">
                     <a4j:jsFunction name="ok" id="ok" 
            action="#{ManagedCertificadosSanitarios.buscarProductoControlMarcas_action}" reRender="dataMarcasProducto"/>
                   <rich:panel headerClass="headerClassACliente" style="width:80%;align:center">
                                    <f:facet name="header">
                                            <h:outputText value="Certificados de Marca Producto"/>
                                    </f:facet>

                                    <h:panelGrid columns="6">
                                        <h:outputText value="Nombre Marca:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedCertificadosSanitarios.marcasProductoBean.nombreMarcaProducto}" styleClass="inputText" style="width:100%"/>
                                        <h:outputText value="Resolucion de Renovacion:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedCertificadosSanitarios.marcasProductoBean.urlRenovacionResolucion}" styleClass="inputText" style="width:100%"/>
                                        <h:outputText value="De fecha Registro" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                         <h:panelGroup>
                                             <h:inputText value="#{ManagedCertificadosSanitarios.fechaInicioRegistroBuscar}"   styleClass="inputText"  id="fechaInicio"  size="15"  >
                                                 <f:convertDateTime pattern="dd/MM/yyyy"   />
                                        </h:inputText>
                                        <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha2" />
                                        <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaInicio' click_element_id='form1:imagenFecha2'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                        <h:outputText value="A fecha Registro:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:panelGroup>
                                            <h:inputText value="#{ManagedCertificadosSanitarios.fechaFinalRegistroBuscar}"   styleClass="inputText"  id="fechaFinal"  size="15" >
                                                         <f:convertDateTime pattern="dd/MM/yyyy"   />
                                                </h:inputText>
                                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha3" />
                                                <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaFinal' click_element_id='form1:imagenFecha3'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                          <h:outputText value="De fecha Vencimiento" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                         <h:panelGroup>
                                             <h:inputText value="#{ManagedCertificadosSanitarios.fechaInicioVencimientoBuscar}"   styleClass="inputText"  id="fechaInicio2"  size="15"  >
                                                 <f:convertDateTime pattern="dd/MM/yyyy"   />
                                        </h:inputText>
                                        <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha22" />
                                        <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaInicio2' click_element_id='form1:imagenFecha22'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                        <h:outputText value="A fecha Vencimiento" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:panelGroup>
                                            <h:inputText value="#{ManagedCertificadosSanitarios.fechaFinalVencimientoBuscar}"   styleClass="inputText"  id="fechaFinal2"  size="15" >
                                                         <f:convertDateTime pattern="dd/MM/yyyy"   />
                                                </h:inputText>
                                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha32" />
                                                <h:outputText value="<DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'  input_element_id='form1:fechaFinal2' click_element_id='form1:imagenFecha32'></DLCALENDAR>"  escape="false"  />
                                        </h:panelGroup>
                                        <h:outputText value="Ordenar fecha:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.ordenarFechaMarca}" styleClass="inputText">
                                            <f:selectItem itemValue="0" itemLabel="-Ninguno-"/>
                                            <f:selectItem itemValue="1" itemLabel="Ascendentemente"/>
                                            <f:selectItem itemValue="2" itemLabel="Descendentemente"/>
                                        </h:selectOneMenu>
                                        <h:outputText value="Estado Marca:" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneMenu value="#{ManagedCertificadosSanitarios.marcasProductoBean.estadosMarcaProducto.codEstadoMarcaProducto}"
                                        styleClass="inputText">
                                            <f:selectItem itemValue='0' itemLabel="-TODOS-"/>
                                            <f:selectItems value="#{ManagedCertificadosSanitarios.estadosMarcasProductoSelectList}"/>
                                            <f:selectItem itemValue='-1' itemLabel="Proximos a Vencer"/>
                                            <f:selectItem itemValue='-2' itemLabel="Vencido"/>
                                        </h:selectOneMenu>
                                    </h:panelGrid>
                                    <center><a4j:commandButton value="BUSCAR" action="#{ManagedCertificadosSanitarios.buscarProductoControlMarcas_action}" styleClass="btn"
                                    reRender="dataMarcasProducto"/></center>
                    </rich:panel>
                    <table style="margin-top:12px">
                        <tr>
                            <%--td><h:outputText styleClass="outputText2" value="Registrados" style="font-weight:bold"/> </td><td class="registrado" style="width:50px"></td--%>
                            <td><h:outputText styleClass="outputText2" value="Proximos a Vencer(3 meses)" style="font-weight:bold"/> </td><td class="proximoVencimiento" style="width:50px"></td>
                            <td><h:outputText styleClass="outputText2" value="Vencidos" style="font-weight:bold"/> </td><td class="vencido" style="width:50px"></td>
                        </tr>
                    </table>
                    <rich:dataTable value="#{ManagedCertificadosSanitarios.marcasProductoList}" var="data"
                                    id="dataMarcasProducto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="margin-top:12px"
                                    >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"/>
                        </rich:column >  

                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Nombre Marca"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreMarcaProducto}"  />
                        </rich:column >  
                       
                        
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Resolucion de Renovación"  />
                            </f:facet>
                            <h:outputText value="#{data.resolucionRenovacion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadosMarcaProducto.nombreEstadoMarcaProducto}"  />
                        </rich:column >
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Renovacion"  />
                            </f:facet>
                            <h:outputText value="SI"  rendered="#{data.productoRenovacion}" />
                            <h:outputText value="NO"  rendered="#{!data.productoRenovacion}" />
                        </rich:column >
                       <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Registro Marca"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaRegistroMarca}" rendered="#{data.fechaRegistroMarca!=null}" >
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                        </rich:column >
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Fecha Vencimiento Marca"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaExpiracionMarca}" rendered="#{data.fechaExpiracionMarca!=null}" >
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                </h:outputText>
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Subir Certificado de Renovación"  />
                            </f:facet>
                            <a4j:commandLink oncomplete="verRegistro('#{data.codMarcaProducto}');Richfaces.showModalPanel('modalPanelSubirArchivo');">
                                <h:graphicImage url="../img/subir.png"/>
                            </a4j:commandLink>
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Quitar Certificado de Renovación"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedCertificadosSanitarios.eliminarURLMarcaProducto}" oncomplete="if(#{ManagedCertificadosSanitarios.mensaje eq '1'}){alert('Se elimino el pdf');}
                                            else{alert('#{ManagedCertificadosSanitarios.mensaje}')}" reRender="dataMarcasProducto"  rendered="#{data.urlRenovacionResolucion !=''}">
                                <f:param name="codMarca" value="#{data.codMarcaProducto}"/>
                                <h:graphicImage url="../img/menos.png"/>

                            </a4j:commandLink>
                        </rich:column>
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Ver Certificado de Renovación" />
                            </f:facet>
                            <a4j:commandLink  oncomplete="verCopiaControlada('#{data.urlRenovacionResolucion}')" title="Ver Certificado Sanitario" rendered="#{data.urlRenovacionResolucion !=''}">
                                <h:graphicImage url="../img/pdf.jpg"/>
                            </a4j:commandLink>
                        </rich:column >
                        
                        
                    </rich:dataTable>
                    <center style="margin-top:1em">
                        <a4j:commandButton value="Agregar" styleClass="btn" action="#{ManagedCertificadosSanitarios.agregarMarcasProducto}"
                        oncomplete="var a =Math.random();window.location.href='agregarMarcaProducto.jsf?coda='+a"/>
                        <a4j:commandButton value="Editar" styleClass="btn" action="#{ManagedCertificadosSanitarios.editarMarcasProducto}"
                        oncomplete="var b=Math.random();window.location.href='editarMarcasProducto.jsf?bb='+b"/>
                        <a4j:commandButton value="Eliminar" styleClass="btn" action="#{ManagedCertificadosSanitarios.eliminarMarcasProducto_action}"
                        reRender="dataMarcasProducto" oncomplete="if(#{ManagedCertificadosSanitarios.mensaje eq '1'}){alert('Se elimino la marca');}else{alert('#{ManagedCer}')}"/>
                    </center>
                    
                    
                </div>
               
            </h:form>

            <rich:modalPanel id="modalPanelSubirArchivo" minHeight="450" headerClass="headerClassACliente"
                                     minWidth="550" height="450" width="700" zindex="100" >
            <f:facet name="header">
                <h:outputText value="Subir Certificado de marca"/>
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

