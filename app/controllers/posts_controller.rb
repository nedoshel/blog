# -*- coding: utf-8 -*-
class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.paginate(page: params[:page], per_page: 20, order: "id desc")
    @post = Post.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { redirect_to posts_path, flash: { error: @post.errors.full_messages } }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

end
