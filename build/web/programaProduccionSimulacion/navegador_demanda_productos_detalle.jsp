
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
    <script type="text/javascript" src="../js/general.js" ></script> 
    <script>
                function cogerId(obj){
                    alert(obj);
                   
                  
                }
                function getCodigo(codigo,codFormula,nombre,cantidad, codProd,codLoteProd,codTipoProgramaProd){
                  //  alert(codLoteProd);
                  izquierda = (screen.width) ? (screen.width-300)/2 : 100 
                  arriba = (screen.height) ? (screen.height-400)/2 : 200 		
                  //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';			
                  url='detalle_navegador_programa_prod.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&codCompProd='+codProd+'&cod_lote_prod='+codLoteProd+'&codTipoProgramaProd='+codTipoProgramaProd;
                  //alert(url);
                  opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                  window.open(url, 'popUp',opciones)

                }
                function getCodigoReserva(codigo){
                
                  		
                  location='../reporteExplosionProductosSimulacion/guardarReservaProgramaProd.jsf?codigo='+codigo;


                }

                function editarItem(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    //alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }    
                
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
    function nuevoAjax()
    {	var xmlhttp=false;
                try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                    try {
 			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        	xmlhttp = false;
                    }                    
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                       xmlhttp = new XMLHttpRequest();
                    }
                    return xmlhttp;
     }
     function enviar(codProgramaProduccion, codigo, fecha_ini, fecha_fin,conProductosEnProceso){
        var ajax=nuevoAjax();
        var valores='codProgramaProduccion='+codProgramaProduccion+'&codigos='+codigo+'&fecha_inicio='+fecha_ini+'&fecha_final='+fecha_fin+'&conProductosEnProceso='+conProductosEnProceso;
        valores+='&pq='+(Math.random()*1000);        
        var url='../reporteExplosionProductosSimulacion/filtroReporteExplosion.jsf';
        ajax.open ('POST', url, true);
        ajax.onreadystatechange = function() {
       
           if (ajax.readyState==1) {
           /* var p=document.createElement('img');
             p.src='../img/load.gif';
             var div=document.createElement('div');
             div.style.paddingTop='150px';
             div.style.paddingLeft='20px';
             div.style.textAlign='center';
             div.style.top='0px';
             div.style.left='0px';
             div.style.position='absolute';
             div.innerHTML='CARGANDO...';
             div.style.fontFamily='Verdana';
             div.style.fontSize='11px';
             div.style.width='200px';
             div.appendChild(p);
             div.style.filter='alpha(opacity=40)';
             main.appendChild(div);
             
             */
             document.getElementById('contenido').style.visibility='visible';
             document.getElementById('contenido').style.zIndex = 5;
             document.getElementById('contenido').style.backgroundColor="#f2f2f2";
             document.getElementById('botones').style.visibility='hidden';
             //document.getElementById('botones').style.left=0px;
             //document.getElementById('botones').style.top=0px;
             
           }else if(ajax.readyState==4){
                // alert(ajax.status);
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var mainGrupo=document.getElementById('panelCenter');
                    //mainGrupo.innerHTML=ajax.responseText;
                    document.write(ajax.responseText);
                    
                    //f=0;
                    //Item(codigo,f);
                }
           }
        }
        ajax.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
        ajax.send(valores);
    }
    function seleccionarTodo(){
       //alert('entro');
       var seleccionar_todo=document.getElementById('form1:seleccionar_todo');
       var elements=document.getElementById('form1:dataFormula');

       if(seleccionar_todo.checked==true){  
         //alert('entro por verdad');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=true;
                }
            }
       }
       else
       {//alert('entro por false');
            var rowsElement=elements.rows;
            for(var i=1;i<rowsElement.length;i++){
                var cellsElement=rowsElement[i].cells;
                var cel=cellsElement[0];
                if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                    cel.getElementsByTagName('input')[0].checked=false;
                }
            }

       }
       return true;

    }
    function trim (myString)
                {
                    return myString.replace(/^\s+/g,'').replace(/\s+$/g,'')
                }

     function seleccionarItem(nametable,producto,lote,check){
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    
                    //se verifica si esta seleccionado
                    //alert(check.checked);

                    if(check.checked==true){
                       for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=true;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }else{
                         for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel0=cellsElement[0];
                        var cel1=cellsElement[1];
                        var cel2=cellsElement[2];
                        var cel3=cellsElement[3];

                    if( trim(cel1.innerHTML) == trim(producto)  && parseFloat(cel3.innerHTML)== parseFloat(lote)  ){
                            //alert("entro 1");
                            cel0.getElementsByTagName('input')[0].checked=false;

                        }else{
                            //alert("entro 2");
                            cel0.getElementsByTagName('input')[0].checked=false;
                        }
                    }

                    }

                   
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
            </script>
</head>
<body >
    
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >
        
        <h:outputText value="#{ManagedDemandaProductos.cargarDemandaProductosDetalle}"  />
        <h:outputText styleClass="outputTextTitulo"  value="Demanda de Productos" />
        <br>
            <rich:dataTable value="#{ManagedDemandaProductos.demandaProductosDetalleList}"
                        var="data" id="dataDemandaProductosDetalle"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente"
                         >
            
            
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Producto"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant. Lote"  />
                </f:facet>
                <h:outputText value="#{data.formulaMaestra.cantidadLote}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Prod. MC"  />
                </f:facet>
                <h:outputText value="#{data.cantProdMC}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Prod. MM"  />
                </f:facet>
                <h:outputText value="#{data.cantProdMM}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Prod. MI"  />
                </f:facet>
                <h:outputText value="#{data.cantProdMI}"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Lotes MC"  />
                </f:facet>
                <h:inputText value="#{data.cantLotesMC}" size="4"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Lotes MM"  />
                </f:facet>
                <h:inputText value="#{data.cantLotesMM}" size="4"  />
            </h:column>
            <h:column>
                <f:facet name="header">
                    <h:outputText value="Cant Lotes MI"  />
                </f:facet>
                <h:inputText value="#{data.cantLotesMI}" size="4"  />
            </h:column>
            
        </rich:dataTable>
        <h:commandButton value="Generar Simulacion de Programa Produccion" action="#{ManagedDemandaProductos.generarProgramaProduccionSimulacion}" />
        
        <br>
        
        
        <div align="center" style="visibility:hidden; " id="contenido"  >
            <p>Cargando.....</p>  
            <img src="../img/load.gif" valign="center" >
        </div>
    </div>
    </a4j:form>
    
</body>
</html>

</f:view>

