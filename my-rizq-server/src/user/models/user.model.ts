import { ObjectType, Field, Int } from '@nestjs/graphql';
import { Post } from './post.model';

@ObjectType()
export class User {
  @Field(() => Int)
  id: number;

  @Field()
  email: string;

  @Field()
  name: string;

  @Field(() => [Post], { nullable: true })
  posts?: Post[];
}
