// src/modules/submissions/mockData.ts
// Realistic mock dataset for submissions module

export interface MockSubmission {
  id: string;
  code: string;          // NN-NNNNN format (e.g., 17-64795)
  title: string;
  category: string;
  payment: 'ok' | 'pending' | 'issue';
  material: 'ok' | 'warning' | 'issue';
  selected?: boolean;
  contactName?: string;   // optional contact for demo
  contactEmail?: string;
  internalNotes?: string;
  projectUrl?: string;
  dropboxUrl?: string;
}

export const mockSubmissions: MockSubmission[] = [
  { id: '1', code: '17-64795', title: 'Disseny exposició', category: 'Branding', payment: 'ok', material: 'warning', contactName: 'Anna Puig', contactEmail: 'anna@estudi.com', internalNotes: 'Pendent d\'aprovació final', projectUrl: 'https://projecte1.com', dropboxUrl: 'https://dropbox.com/1' },
  { id: '2', code: '18-02341', title: 'Campanya gràfica', category: 'Publicitat', payment: 'pending', material: 'ok', contactName: 'Joan Vidal', contactEmail: 'joan@agencia.cat', internalNotes: 'Revisió de proofs', projectUrl: 'https://campanya2.com', dropboxUrl: 'https://dropbox.com/2' },
  { id: '3', code: '19-11223', title: 'Web corporativa', category: 'Digital', payment: 'ok', material: 'issue', contactName: 'Marta Soler', contactEmail: 'marta@web.cat', internalNotes: 'Falten continguts', projectUrl: 'https://web3.com', dropboxUrl: 'https://dropbox.com/3' },
  { id: '4', code: '20-33456', title: 'Identitat visual', category: 'Branding', payment: 'ok', material: 'ok', contactName: 'Pau Roca', contactEmail: 'pau@estudi.com', internalNotes: 'Lliurat', projectUrl: 'https://identitat4.com', dropboxUrl: 'https://dropbox.com/4' },
  { id: '5', code: '21-44567', title: 'Anunci televisiu', category: 'Audiovisual', payment: 'pending', material: 'warning', contactName: 'Laia Font', contactEmail: 'laia@tv.cat', internalNotes: 'Pendent de pagament', projectUrl: 'https://spot5.com', dropboxUrl: 'https://dropbox.com/5' },
  { id: '6', code: '22-55678', title: 'Packaging producte', category: 'Packaging', payment: 'ok', material: 'ok', contactName: 'Carles Mas', contactEmail: 'carles@pack.cat', internalNotes: 'A punt per enviar', projectUrl: 'https://pack6.com', dropboxUrl: 'https://dropbox.com/6' },
  { id: '7', code: '23-66789', title: 'Il·lustració editorial', category: 'Editorial', payment: 'issue', material: 'ok', contactName: 'Laura Estrany', contactEmail: 'laura@il·lustra.cat', internalNotes: 'Reclamació pendent', projectUrl: 'https://il·lustra7.com', dropboxUrl: 'https://dropbox.com/7' },
  { id: '8', code: '24-77890', title: 'Tipografia custom', category: 'Digital', payment: 'ok', material: 'warning', contactName: 'Gerard Font', contactEmail: 'gerard@tipografia.com', internalNotes: 'Llicència per revisar', projectUrl: 'https://font8.com', dropboxUrl: 'https://dropbox.com/8' },
  { id: '9', code: '25-88901', title: 'Senyalització', category: 'Espai', payment: 'pending', material: 'issue', contactName: 'Cristina Pla', contactEmail: 'cristina@senyal.cat', internalNotes: 'Material no rebut', projectUrl: 'https://senyal9.com', dropboxUrl: 'https://dropbox.com/9' },
  { id: '10', code: '26-99012', title: 'Aplicació mòbil', category: 'Digital', payment: 'ok', material: 'ok', contactName: 'Albert Rius', contactEmail: 'albert@app.cat', internalNotes: 'Publicada', projectUrl: 'https://app10.com', dropboxUrl: 'https://dropbox.com/10' },
  { id: '11', code: '27-10123', title: 'Catàleg exposició', category: 'Editorial', payment: 'ok', material: 'ok', contactName: 'Núria Valls', contactEmail: 'nuria@cataleg.cat', internalNotes: 'Enviat a impremta', projectUrl: 'https://cataleg11.com', dropboxUrl: 'https://dropbox.com/11' },
  { id: '12', code: '28-21234', title: 'Fotografia campanya', category: 'Fotografia', payment: 'pending', material: 'warning', contactName: 'Toni Mir', contactEmail: 'toni@foto.cat', internalNotes: 'Esperant selecció', projectUrl: 'https://foto12.com', dropboxUrl: 'https://dropbox.com/12' },
  { id: '13', code: '29-32345', title: 'Vídeo corporatiu', category: 'Audiovisual', payment: 'ok', material: 'issue', contactName: 'Sílvia Grau', contactEmail: 'silvia@video.cat', internalNotes: 'Falta llicència música', projectUrl: 'https://video13.com', dropboxUrl: 'https://dropbox.com/13' },
  { id: '14', code: '30-43456', title: 'Eines de comunicació', category: 'Gràfic', payment: 'ok', material: 'ok', contactName: 'Oriol Cases', contactEmail: 'oriol@eines.cat', internalNotes: 'Material complet', projectUrl: 'https://eines14.com', dropboxUrl: 'https://dropbox.com/14' },
  { id: '15', code: '31-54567', title: 'Instal·lació artística', category: 'Espai', payment: 'issue', material: 'ok', contactName: 'Mònica Serra', contactEmail: 'monica@instal·lacio.cat', internalNotes: 'Esperant confirmació', projectUrl: 'https://instal·lacio15.com', dropboxUrl: 'https://dropbox.com/15' },
  { id: '16', code: '32-65678', title: 'Disseny de producte', category: 'Producte', payment: 'pending', material: 'warning', contactName: 'Ramon Coll', contactEmail: 'ramon@producte.cat', internalNotes: 'Prototip en revisió', projectUrl: 'https://producte16.com', dropboxUrl: 'https://dropbox.com/16' },
  { id: '17', code: '33-76789', title: 'Interfície d\'usuari', category: 'Digital', payment: 'ok', material: 'ok', contactName: 'Helena Bosch', contactEmail: 'helena@ui.cat', internalNotes: 'Entregat', projectUrl: 'https://ui17.com', dropboxUrl: 'https://dropbox.com/17' },
  { id: '18', code: '34-87890', title: 'Animació 2D', category: 'Audiovisual', payment: 'ok', material: 'issue', contactName: 'David Parra', contactEmail: 'david@animacio.cat', internalNotes: 'Revisar format', projectUrl: 'https://animacio18.com', dropboxUrl: 'https://dropbox.com/18' },
  { id: '19', code: '35-98901', title: 'Llibre d\'artista', category: 'Editorial', payment: 'pending', material: 'ok', contactName: 'Carme Roca', contactEmail: 'carme@llibre.cat', internalNotes: 'Pendent de distribució', projectUrl: 'https://llibre19.com', dropboxUrl: 'https://dropbox.com/19' },
  { id: '20', code: '36-09012', title: 'Estratègia de marca', category: 'Branding', payment: 'ok', material: 'ok', contactName: 'Jordi Solà', contactEmail: 'jordi@marca.cat', internalNotes: 'Complet', projectUrl: 'https://marca20.com', dropboxUrl: 'https://dropbox.com/20' },
];