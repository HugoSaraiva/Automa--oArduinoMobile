#include <x10.h>
#include <x10constants.h>


#include <SPI.h>
#include <Ethernet.h>

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
byte mac[] = { 
  0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
IPAddress ip(192,168,0,177);

// Initialize the Ethernet server library
// with the IP address and port you want to use 
// (port 80 is default for HTTP):
EthernetServer server(80);

#define NDISPOSITIVOS 3
int codigos[NDISPOSITIVOS] = {4, 5, 6};
int estados[NDISPOSITIVOS] = {0, 0, 0};
String nomes[NDISPOSITIVOS] = {"Luz Amarela", "Luz Verde   ", "Luz Vermelha"};

// For sending HTML to the client
#define STRING_BUFFER_SIZE 20
char buffer[STRING_BUFFER_SIZE];
int bufindex = 0; // reset buffer
char compare[STRING_BUFFER_SIZE];

x10 casa;

int codigocasa = 1;

void setup() {
 // Open serial communications and wait for port to open:
  Serial.begin(9600);
  casa = x10(9, 10);
   while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }


  // start the Ethernet connection and the server:
  Ethernet.begin(mac, ip);
  server.begin();
  Serial.print("server is at ");
  Serial.println(Ethernet.localIP());
}

String traduzirEstado(int estado) {
  String traducao = "Ligado";
  if (estado != 1)
     traducao = "Desligado";
  return traducao; 
}

void avaliarAlteracao(int variavel, bool mobile) {
  if (mobile)
    strcpy(compare, "GET /mobileAlterar");
  else 
    strcpy(compare, "GET /Alterar");
  
  int indice = -1;
  if (variavel == 4) {
     strcat(compare, "4");
     indice = 0;
  }
  else if (variavel == 5) {
     strcat(compare, "5");
     indice = 1;
  }
  else if (variavel == 6) {
     strcat(compare, "6");
     indice = 2;
  }
  
  if (strncmp(buffer, compare, strlen(compare))==0) {
     estados[indice] = !estados[indice];   
  }
}

void responderHTML(EthernetClient client, bool conf) {

          for (int i=0;i<NDISPOSITIVOS;i++) {
             avaliarAlteracao(estados[i], false); 
          }         
          
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println("Connection: close");  // the connection will be closed after completion of the response
          client.println();          
          client.println("<!DOCTYPE HTML>");
          client.println("<html>");
          client.println("<head>");
          client.println("<title>Controlador Arduino</title>");
          client.println("<meta charset=\"UTF-8\">");
          client.println("</head>");
          client.println("<body>");
          client.println("<div>Domótica - TCC HUGO SARAIVA</div>");
          if (conf)
            client.println("<div>Configuração</div>");
          else
            client.println("<div>Controles</div>");
          client.println("<br/>");
          client.println("<br/>");
          client.println("<table>");
          client.println("<tr>");
          client.println("<td>Dispositivo</td>");
          if (!conf) 
            client.println("<td>Status</td>");
          client.println("<td>Ação</td>");
          client.println("</tr>");
          for (int i=0;i<NDISPOSITIVOS;i++) {
            client.println("<tr>");
            if (conf) {
              client.println("<td><input type='text' id='edtTexto" + String(codigos[i]) + "' value='" + nomes[i] + "'></td>");
            }
            else {
              client.println("<td>" + nomes[i] + "</td>");
              client.println("<td>" + traduzirEstado(estados[i]) + "</td>");
            }
            client.println("<td><a href='Alterar" + String(codigos[i]) + "'>Alterar</a></td>");
            client.println("</tr>");
          }
          client.println("</table>");
          client.println("<br/>");
          if (conf) {
            client.println("<table>");
            client.println("<tr>");
            client.println("<td>Câmera</td>");
            client.println("<td>IP</td>");
            client.println("</tr>");
            client.println("<tr>");
            client.println("<td><input type='text' id='edtIP' value='192.168.1.101'></td>");
            client.println("<td><input type='button' id='btnIP' value='Alterar'></td>");
            client.println("</tr>");
            client.println("</table>");
          }
          else {
            client.println("<div><a href='192.168.0.101'>Ver câmera</a></div>");
          }
          client.println("<br/>");
          if (conf)
             client.println("<div><a href='controles'>Controles</a></div>");
          else
             client.println("<div><a href='configuracao'>Configuração</a></div>");
          client.println("</body>");
          client.println("</html>");
}

void responderMobile(EthernetClient client) {
          for (int i=0;i<NDISPOSITIVOS;i++) {
             avaliarAlteracao(estados[i], true); 
          }           
          
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/xml");
          client.println("Connection: close");  // the connection will be closed after completion of the response
          client.println();           
          client.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");        
          client.println("<Documento>");
          
          for (int i=0;i<NDISPOSITIVOS;i++) {
            client.println("<Dispositivo>");
            client.println("<Codigo>" + String(codigos[i]) + "</Codigo>");
            client.println("<Descricao>" + nomes[i] + "</Descricao>");
            client.println("<Status>" + traduzirEstado(estados[i]) + "</Status>");
            client.println("</Dispositivo>");
          }
          
          client.println("</Documento> ");
}

void loop() {
  // listen for incoming clients
  EthernetClient client = server.available();
  if (client) {
    Serial.println("new client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    char c;
    
         buffer[0] = client.read();
         buffer[1] = client.read();
         bufindex = 2;
         // read the first line to determinate the request page
         while (buffer[bufindex-2] != '\r' && buffer[bufindex-1] != '\n') { // read full row and save it in buffer
            c = client.read();
            if (bufindex<STRING_BUFFER_SIZE) buffer[bufindex] = c;
            bufindex++;
         }
         
    while (client.connected()) {
      if (client.available()) {
        Serial.write(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        c = client.read();
        
        if (c == '\n' && currentLineIsBlank) {
          
          strcpy(compare, "GET /mobile");
          if (strncmp(buffer, compare, strlen(compare))==0) 
            responderMobile(client);
          else {
            strcpy(compare, "GET /configuracao");
            if (strncmp(buffer, compare, strlen(compare))==0) 
               responderHTML(client, true);
            else
               responderHTML(client, false); 
          }
            
          break;
        }
        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } 
        else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    // close the connection:
    client.stop();
    Serial.println("client disconnected");
    for (int i=0;i<NDISPOSITIVOS;i++) {
      casa.write(1, codigos[i], estados[i]); 
    }   
  }
}
