const DB = {
  likes: new Map<string, Set<string>>(),
  counts: new Map<string, number>(),
};

export function getLikeCount(postid: string): number {
  const count = DB.get(postid);
  if (count === undefined) {
    return 0;
  }
  return count.size;
}

export function incrementLikeCount(postid: string): void {
  const likes = DB.get(postid);
  if (likes === undefined) {
    DB.set(postid, new Set());
  }
  likes.add(userId);
  DB.set(postid, likes);
}

export function decrementLikeCount(postid: string): void {
  DB.set(postid, (getLikeCount(postid) - 1));
}

export function isLiked(postid: string, userId: string): boolean {
  const count = DB.get(postid);
  if (count === undefined) {
    return false;
  }
  return count.has(userId);
}