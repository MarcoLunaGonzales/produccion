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
                    background-color:#98FB98;
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
                function verRegistro(codProd)
                {
                    var a=new Date();
                    document.getElementById('frameSubir').src="subirArchivoPdf.jsf?codProd="+codProd+"&a="+Math.random()+"&date="+(a.getTime.toString());
                }
                function ocultaRegistro()
                {
                    Richfaces.hideModalPanel('modalPanelSubirArchivo');
                }
                function refrescar()
                {
                    ok();
                }

            </script>
        </head>
        <body>
           
            <h:form id="form1"  >
                <div align="center">
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="Registro de Marca"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Nombre Marca" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputText value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.nombreMarcaProducto}"
                            styleClass="inputText" style="width:25em"/>
                            <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectOneMenu value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.estadosMarcaProducto.codEstadoMarcaProducto}"
                            styleClass="inputText">
                                <f:selectItems value="#{ManagedCertificadosSanitarios.estadosMarcasProductoSelectList}"/>
                            </h:selectOneMenu>
                            <h:outputText value="Resolucion de Renovacion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputText value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.resolucionRenovacion}"
                            styleClass="inputText" style="width:25em"/>
                            <h:outputText value="Fecha Registro Marca" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <rich:calendar value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.fechaRegistroMarca}" datePattern="dd/MM/yyyy" styleClass="inputText"/>
                            <h:outputText value="Producto que se renovara" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:selectBooleanCheckbox value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.productoRenovacion}"/>
                            <h:outputText value="Observacion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:inputTextarea value="#{ManagedCertificadosSanitarios.marcasProductoAgregar.observacion}" style="width:25em" rows="4" styleClass="inputText"/>






                        </h:panelGrid>
                         <CENTER STYLE="margin-top:1em">
                            <a4j:commandButton value="Guardar" styleClass="btn" action="#{ManagedCertificadosSanitarios.guardarNuevaMarcaProducto_action}"
                            oncomplete="if(#{ManagedCertificadosSanitarios.mensaje eq '1'}){alert('Se registro la marca');var a=Math.random();
                            window.location.href='navegadorControlMarcasCertificado.jsf?a='+a;}else{alert('#{ManagedCertificadosSanitarios.mensaje}');}"/>
                            <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();
                            window.location.href='navegadorControlMarcasCertificado.jsf?a='+a;"/>
                        </CENTER>
                    </rich:panel>
                  
                   
                    
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

