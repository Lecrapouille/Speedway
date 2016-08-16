unit libre;

interface
uses
  typege;

procedure libererobjet(var Obj : TObjet);

implementation

procedure libererobjet(var Obj : TObjet);
var Texture : pTexture;
    Mesh : pMesh;
    Vertex :pVertex;
    Face : pFace;
begin
   // liberer les textures
   obj.TextureQueue := obj.TextureHead.Next;
   while obj.TextureQueue<>NIL do
   begin
      Texture := obj.TextureQueue;
      obj.TextureQueue := obj.TextureQueue.Next;
      freemem(Texture);
   end;
   // liberer les mesh
   obj.MeshQueue := obj.MeshHead.Next;
   while obj.MeshQueue<>NIL do
   begin
      // liberer les vertexs
      obj.MeshQueue.VertexQueue := obj.MeshQueue.VertexHead.Next;
      while obj.MeshQueue.VertexQueue<>NIL do
      begin
         Vertex := obj.MeshQueue.VertexQueue;
         obj.MeshQueue.VertexQueue := obj.MeshQueue.VertexQueue.Next;
         freemem(Vertex);
      end;
      // liberer les faces
      obj.MeshQueue.FaceQueue := obj.MeshQueue.FaceHead.Next;
      while obj.MeshQueue.FaceQueue<>NIL do
      begin
         Face := obj.MeshQueue.FaceQueue;
         obj.MeshQueue.FaceQueue := obj.MeshQueue.FaceQueue.Next;
         freemem(Face);
      end;
      // liberer les vertexs
      obj.MeshQueue.CoordTextQueue := obj.MeshQueue.CoordTextHead.Next;
      while obj.MeshQueue.CoordTextQueue<>NIL do
      begin
         Vertex := obj.MeshQueue.CoordTextQueue;
         obj.MeshQueue.CoordTextQueue := obj.MeshQueue.CoordTextQueue.Next;
         freemem(Vertex);
      end;
      Mesh := obj.MeshQueue;
      obj.MeshQueue := obj.MeshQueue.Next;
      freemem(Mesh);
   end;
   // liberer les textures
   // liberer les textures
   // liberer les textures
end;

end.
