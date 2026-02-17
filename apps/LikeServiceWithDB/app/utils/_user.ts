export function getUserId(): string {
  // get userid from jwt token
  return Math.random().toString(36).substring(2, 15);
}
