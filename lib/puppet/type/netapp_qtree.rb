require 'puppet/util/network_device'

Puppet::Type.newtype(:netapp_qtree) do
  @doc = "Manage Netapp Qtree creation, modification and deletion. [Family: vserver]"

  apply_to_device

  ensurable

  newparam(:name) do
    desc "The qtree name."
    validate do |value|
      unless (value =~ /^[\w\-]+$/) or (value =~ /^\/\w+\/\w+$/)
         raise ArgumentError, "%s is not a valid qtree name." % value
      end
    end
  end

  newproperty(:volume) do
    isnamevar
    desc "The volume to create qtree against."
    defaultto do
      if @resource[:name].count('/') == 2
        @resource[:name].split('/')[1]
      else
        ""
      end
    end
    validate do |value|
      unless value =~ /^\w+$/
         raise ArgumentError, "%s is not a valid volume name." % value
      end
    end
  end

  newproperty(:qtname) do
    isnamevar
    desc "The qtname to create."
    defaultto do
      if @resource[:name].count('/') == 2
        @resource[:name].split('/')[2]
      else
        @resource[:name]
      end
    end
    validate do |value|
      unless value =~ /^[\w\-]+$/
         raise ArgumentError, "%s is not a valid qtname name." % value
      end
    end
  end

  newproperty(:exportpolicy) do
    desc "The export policy with which the qtree is associated."
  end

  autorequire(:netapp_volume) do
    self[:volume]
  end
  autorequire(:netapp_export_policy) do
    self[:exportpolicy]
  end
end
