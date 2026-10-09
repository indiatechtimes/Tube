class VideoModel {
  final String id;
  final String title;
  final String thumbnail;
  final String ownerName;

  const VideoModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.ownerName,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'];

    return VideoModel(
      
      
      id: (json['_id'] ?? json['id'] ?? "").toString(),
      title: (json['title']?? "").toString(),
      thumbnail: (json['thumbnail']??'').toString(),
      ownerName: owner is Map ? (owner['userName']??"").toString():'',
      

      
    
    
    
    
    
    
    
    
    );
  }
}
