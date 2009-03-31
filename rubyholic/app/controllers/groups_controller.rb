class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.xml
  def index
    @search_terms = nil
    if params[:q] then
      @search_terms = params[:q]
      order_by = nil
      order_by = params[:sort].to_sym if params[:sort]
      
      @groups = Group.search params[:q], :page => params[:page], :order => order_by
    else
      case params[:sort]
        when "name" then 
          @groups = Group.sort(params[:sort], params[:page])
        when "location" then 
          # yeah, this is fugly!
          @groups = Group.sort("locations.name", params[:page])
        else                 
          @groups = Group.index(params[:page])
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.xml
  def show
    @group = Group.find(params[:id])

    if @group.locations
      @map = GMap.new("map_div")
      @map.control_init(:large_map => true, :map_type => true)
      @map.center_zoom_init([@group.locations.first.latitude, @group.locations.first.longitude],14)
      @map.overlay_init(GMarker.new([@group.locations.first.latitude, @group.locations.first.longitude],
        :title        => @group.locations.first.name,
        :info_window  => @group.locations.first.notes
      ))
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
end
